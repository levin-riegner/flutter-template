import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/connectivity_helper.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_content_placeholder_views.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_loading_indicator.dart';
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
    Key? key,
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
        shouldListenForScroll = onScroll != null,
        super(key: key);

  @override
  State<InAppWebView> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  static const int enoughProgressPercentage = 80;

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

  late final WebViewController _controller;

  bool? hasInternet;
  bool isLoadingPage = false;

  StreamSubscription? internetSubscription;
  StreamSubscription? _scrollSubscription;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ?? WebViewController())
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
              _controller.runJavaScript(
                "document.body.style.webkitTouchCallout='none';",
              );

              // Scroll listener
              if (widget.shouldListenForScroll) {
                _scrollSubscription?.cancel();
                _scrollSubscription =
                    Stream.periodic(const Duration(milliseconds: 250), (i) => i)
                        .asyncMap((event) {
                  return _controller.runJavaScriptReturningResult(
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

  @override
  void dispose() {
    internetSubscription?.cancel();
    _scrollSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = hasInternet != false
        ? Stack(
            children: <Widget>[
              WebViewWidget(
                controller: _controller,
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

class WebViewAction {
  final String message;
  final VoidCallback onReceived;

  WebViewAction({
    required this.message,
    required this.onReceived,
  });
}
