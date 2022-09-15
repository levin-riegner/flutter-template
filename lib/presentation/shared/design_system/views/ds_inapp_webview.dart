import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/connectivity_helper.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_content_placeholder_views.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebView extends StatefulWidget {
  final ValueNotifier<String> urlNotifier;
  final String javascriptChannelName;
  final List<WebViewAction> actions;
  final bool useScaffold;
  final String? title;
  final Color? backgroundColor;
  final String? userAgent;
  final String? userToken;
  final Widget noInternetView;
  final bool enableHybridComposition;

  const InAppWebView({
    Key? key,
    required this.urlNotifier,
    this.javascriptChannelName = "MobileApp",
    this.actions = const [],
    this.title,
    this.backgroundColor,
    this.userAgent,
    this.userToken,
    bool useScaffold = false,
    Widget? noInternetView,
    this.enableHybridComposition = true,
  })  : useScaffold = title != null || useScaffold,
        noInternetView = noInternetView ?? const DSNoInternetView(),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InAppWebViewState();
  }
}

class _InAppWebViewState extends State<InAppWebView> {
  bool? hasInternet;
  StreamSubscription? internetSubscription;

  WebViewController? webViewController;

  _reloadUrl() {
    setState(() {
      webViewController?.loadUrl(
        widget.urlNotifier.value,
        headers: (widget.userToken != null)
            ? {"Authorization": "Bearer ${widget.userToken}"}
            : null,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.enableHybridComposition && Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    // Subscribe to Url changes
    widget.urlNotifier.addListener(_reloadUrl);
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
    // Unsubscribe to Url changes
    widget.urlNotifier.removeListener(_reloadUrl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Prepare Javascript Channels
    List<JavascriptChannel> javascriptChannels = [
      JavascriptChannel(
        name: widget.javascriptChannelName,
        onMessageReceived: (JavascriptMessage result) {
          debugPrint("Got JavascriptMessage: ${result.message}");
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
              debugPrint("Unhandled javascript message ${result.message}");
            }
          }
        },
      )
    ];

    // Prepare Webview
    final body = hasInternet != false
        ? WebView(
            initialUrl: widget.urlNotifier.value,
            userAgent: widget.userAgent,
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from(javascriptChannels),
            onWebViewCreated: (WebViewController webViewController) {
              this.webViewController = webViewController;
              // Maybe reload with Auth header
              if (widget.userToken != null) _reloadUrl();
            },
            onPageFinished: (url) {
              // Disable iOS allowLinksPreview
              webViewController!.runJavascript(
                  "document.body.style.webkitTouchCallout='none';");
            },
          )
        : widget.noInternetView;

    return widget.useScaffold
        ? Scaffold(
            backgroundColor: widget.backgroundColor,
            appBar: AppBar(
              title: widget.title != null ? Text(widget.title!) : null,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop()),
              backgroundColor: widget.backgroundColor,
            ),
            body: SafeArea(
              child: body,
            ),
          )
        : body;
  }
}

class WebViewAction {
  final String message;
  final VoidCallback onReceived;

  WebViewAction({required this.message, required this.onReceived});
}
