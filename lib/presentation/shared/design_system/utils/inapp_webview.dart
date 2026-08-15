import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:color_picker/presentation/shared/design_system/utils/connectivity_helper.dart';
import 'package:color_picker/presentation/shared/design_system/views/ds_content_placeholder_views.dart';
import 'package:color_picker/presentation/shared/design_system/views/ds_loading_indicator.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef WebViewCreatedCallback = void Function(WebViewController controller);

class InAppWebView extends StatefulWidget {
  final String initialUrl;
  final String javascriptChannelName;
  final List<WebViewAction> actions;
  final bool useScaffold;
  final String? title;
  final Color? backgroundColor;
  final Color? appBarColor;
  final String? userAgent;
  final String? userToken;
  final Widget noInternetView;
  final Function(double percentage, StreamSubscription<dynamic>?)? onScroll;
  final bool shouldListenForScroll;
  final WebViewController? controller;

  const InAppWebView({
    super.key,
    required this.initialUrl,
    this.javascriptChannelName = "MobileApp",
    this.actions = const [],
    this.title,
    this.backgroundColor,
    this.appBarColor,
    this.userAgent,
    this.userToken,
    bool useScaffold = false,
    Widget? noInternetView,
    this.onScroll,
    this.controller,
  })  : useScaffold = title != null || useScaffold,
        noInternetView = noInternetView ?? const DSNoInternetView(),
        shouldListenForScroll = onScroll != null;

  @override
  State<InAppWebView> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  static const int enoughProgressPercentage = 80;

  /// webview_flutter has no native impl on desktop (linux/windows).
  /// There we fall back to launching the URL in the system browser.
  static bool get _isDesktop => Platform.isLinux || Platform.isWindows;

  static const String kScrollPercentageJavascriptCode = """
        (function getScrollPercent() {
          if(document != null){
            var h = document.documentElement,
              b = document.body,
              st = 'scrollTop',
              sh = 'scrollHeight';
          return (h[st]||b[st]) / ((h[sh]||b[sh]) - h.clientHeight) * 100;
          }
          else {
            return 0;
          }
          
        })();
      """;

  WebViewController? _controller;

  bool? hasInternet;
  bool isLoadingPage = false;

  StreamSubscription? internetSubscription;
  StreamSubscription? _scrollSubscription;

  @override
  void initState() {
    super.initState();
    if (_isDesktop) {
      Flogger.i(
        "In-app webview unavailable on desktop; opening ${widget.initialUrl} "
        "in system browser",
      );
      _openInSystemBrowser();
      return;
    }
    final controller = widget.controller ?? WebViewController();
    _controller = controller;
    _setupController(controller);

    // Check initial connectivity
    ConnectivityHelper.isConnected().then((isConnected) {
      setState(() => hasInternet = isConnected);
      // Listen to connectivity if offline
      if (!isConnected) {
        internetSubscription =
            ConnectivityHelper.onIsConnectedChanged().listen((isConnected) {
          if (isConnected) {
            // Internet recovered, stop listening
            internetSubscription?.cancel();
            setState(() => hasInternet = isConnected);
          }
        });
      }
    });
  }

  /// Configures the webview [controller] and loads the initial request.
  void _setupController(WebViewController controller) {
    controller
      ..setBackgroundColor(widget.backgroundColor ?? Colors.transparent)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            // TODO: Use this to intercept navigation URLs including the first page load
            // and handle them in the app.
            // Use NavigationDecision.prevent to disable navigation.
            Flogger.i("Requesting webview navigation to ${request.url}");
            // getIt.get<DeepLinkManager>().handleDeepLink(Uri.parse(request.url));
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            setState(() {
              isLoadingPage = true;
            });
          },
          onProgress: (progress) {
            if (progress > enoughProgressPercentage && isLoadingPage) {
              setState(() {
                isLoadingPage = false;
              });
              // Disable iOS allowLinksPreview
              controller.runJavaScript(
                "document.body.style.webkitTouchCallout='none';",
              );

              // Scroll listener
              if (widget.shouldListenForScroll) {
                _scrollSubscription?.cancel();
                _scrollSubscription =
                    Stream.periodic(const Duration(milliseconds: 250), (i) => i)
                        .asyncMap((event) {
                  return controller.runJavaScriptReturningResult(
                      kScrollPercentageJavascriptCode);
                }).listen(
                  (event) {
                    double? percentage;

                    if (event is int) {
                      percentage = event.toDouble();
                    } else if (event is String) {
                      percentage = double.tryParse(event);
                    } else {
                      percentage = event as double?;
                    }

                    if (percentage != null) {
                      widget.onScroll?.call(percentage, _scrollSubscription);
                    }
                  },
                );
              }
            }
          },
          onPageFinished: (url) {
            setState(() {
              isLoadingPage = false;
            });
          },
          onWebResourceError: (error) {
            Flogger.d("Got Web Resource Error: ${error.description}");
          },
        ),
      )
      ..setUserAgent(widget.userAgent)
      ..addJavaScriptChannel(
        widget.javascriptChannelName,
        onMessageReceived: (result) {
          Flogger.d("Got JavascriptMessage: ${result.message}");
          try {
            // Find action
            final WebViewAction action = widget.actions
                .firstWhere((action) => action.message == result.message);
            action.onReceived();
          } catch (e) {
            // Action not found
            if (result.message == "back" && widget.useScaffold) {
              // Default back action
              Navigator.of(context).pop();
            } else {
              // Unknown action
              Flogger.d("Unhandled javascript message ${result.message}");
            }
          }
        },
      )
      ..loadRequest(
        Uri.parse(widget.initialUrl),
        headers: (widget.userToken != null)
            ? {"Authorization": "Token ${widget.userToken}"}
            : const <String, String>{},
      );
  }

  Future<void> _openInSystemBrowser() async {
    final uri = Uri.parse(widget.initialUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Flogger.w("No system browser available to open $uri");
    }
  }

  @override
  void dispose() {
    internetSubscription?.cancel();
    _scrollSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return _DesktopFallbackView(
        initialUrl: widget.initialUrl,
        title: widget.title,
        useScaffold: widget.useScaffold,
      );
    }
    final body = hasInternet != false
        ? Stack(
            children: <Widget>[
              WebViewWidget(
                controller: controller,
              ),
              // TODO: This should be a horizontal progressbar on top
              if (isLoadingPage)
                Center(
                  child: DSLoadingIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          )
        : widget.noInternetView;

    return widget.useScaffold
        ? Scaffold(
            appBar: AppBar(
              title: widget.title != null ? Text(widget.title!) : null,
              backgroundColor: widget.appBarColor,
            ),
            body: body,
          )
        : body;
  }
}

/// Shown instead of the embedded webview on desktop platforms, where
/// webview_flutter has no native implementation. Offers to open the URL in
/// the system browser.
class _DesktopFallbackView extends StatelessWidget {
  final String initialUrl;
  final String? title;
  final bool useScaffold;

  const _DesktopFallbackView({
    required this.initialUrl,
    required this.title,
    required this.useScaffold,
  });

  Future<void> _launch() async {
    final uri = Uri.parse(initialUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Flogger.w("No system browser available to open $uri");
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "In-app webview is not available on this platform.",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              initialUrl,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _launch,
            icon: const Icon(Icons.open_in_new),
            label: const Text("Open in browser"),
          ),
        ],
      ),
    );
    return useScaffold
        ? Scaffold(
            appBar: AppBar(title: title != null ? Text(title!) : null),
            body: Center(child: content),
          )
        : Center(child: content);
  }
}

class WebViewAction {
  final String message;
  final VoidCallback onReceived;

  WebViewAction({
    required this.message,
    required this.onReceived,
  });
}
