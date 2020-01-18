import 'dart:async';

import 'package:flutter/material.dart';

typedef OnWidgetChanged<T> = Widget Function(T);

typedef DoAnything<T> = T Function(T);

class BaseBloc<T> {
  var value;
  StreamController<T> controller = StreamController<T>.broadcast();

  BaseBloc(var initialData) {
    this.value = initialData;
  }

  doSomething({@required DoAnything whatTodo}) {
    value=whatTodo(value);
    controller.sink.add(value);
  }

  void dispose() {
    controller.close();
  }

  Widget blocWidget({@required OnWidgetChanged widget}) {
    return StreamBuilder<T>(
        initialData: value,
        stream: controller.stream,
        builder: (context, snapshot) {
          return widget(snapshot.data);
        });
  }
}
