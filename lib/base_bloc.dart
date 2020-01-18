import 'dart:async';

import 'package:flutter/material.dart';

typedef ValueChanged<T> = Widget Function(AsyncSnapshot<T> T);

typedef DoAnything<T> = T Function();

class BaseBloc<T> {
  var initData;
  StreamController<T> controller = StreamController<T>.broadcast();

  BaseBloc(this.initData);

  doAnything({@required DoAnything whatTodo}) {
    controller.sink.add(whatTodo());
  }

  void dispose() {
    controller.close();
  }

  Widget blocWidget({@required ValueChanged widget}) {
    return StreamBuilder<T>(
        initialData: initData,
        stream: controller.stream,
        builder: (context, snapshot) {
          return widget(snapshot);
        });
  }
}
