import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'base_bloc.dart';

abstract class BaseState<T extends StatefulWidget, B extends BaseBloc>
    extends State<T> {
  final List<StreamSubscription> disposeBag = [];
  late B bloc;

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = Provider.of<B>(context);
    _disposeSubscriptions();
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
    _disposeSubscriptions();
  }

  _disposeSubscriptions() => disposeBag.forEach((e) => e.cancel());
}

extension DisposeBag on StreamSubscription {
  void disposedBy(List<StreamSubscription> disposeBag) {
    disposeBag.add(this);
  }
}
