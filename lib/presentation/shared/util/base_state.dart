import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  final List<StreamSubscription> disposeBag = [];

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disposeSubscriptions();
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
    _disposeSubscriptions();
  }

  _disposeSubscriptions() {
    for (var e in disposeBag) {
      e.cancel();
    }
  }
}

extension DisposeBag on StreamSubscription {
  void disposedBy(List<StreamSubscription> disposeBag) {
    disposeBag.add(this);
  }
}
