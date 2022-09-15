import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/connectivity_helper.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_content_placeholder_views.dart';

class DSInternetRequired extends StatefulWidget {
  final Widget child;
  final bool expanded;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onInternetAvailable;

  const DSInternetRequired({
    Key? key,
    this.expanded = true,
    required this.child,
    this.onInternetAvailable,
    this.contentPadding,
  }) : super(key: key);

  @override
  _DSInternetRequiredState createState() => _DSInternetRequiredState();
}

class _DSInternetRequiredState extends State<DSInternetRequired> {
  bool? hasInternet;
  StreamSubscription? internetSubscription;

  @override
  void initState() {
    super.initState();
    // Check initial connectivity
    ConnectivityHelper.isConnected().then((isConnected) {
      if (hasInternet != true) {
        setState(() => hasInternet = isConnected);
        // Listen to connectivity if offline
        if (!isConnected) {
          internetSubscription =
              ConnectivityHelper.onIsConnectedChanged().listen((isConnected) {
            if (isConnected) {
              // Internet recovered, stop listening
              internetSubscription?.cancel();
              setState(() => hasInternet = isConnected);
              // Notify
              widget.onInternetAvailable?.call();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    internetSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return hasInternet == false
        ? DSNoInternetView(
            expanded: widget.expanded,
            contentPadding: widget.contentPadding,
          )
        : widget.child;
  }
}
