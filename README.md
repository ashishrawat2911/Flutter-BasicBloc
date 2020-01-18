# Simple Bloc


## Base Bloc


````
import 'dart:async';

import 'package:flutter/material.dart';

typedef ValueChanged<T> = Widget Function( T);

typedef DoAnything<T> = T Function(T);

class BaseBloc<T> {
  var value;
  StreamController<T> controller = StreamController<T>.broadcast();

  BaseBloc(var initialData) {
    this.value = initialData;
  }

  doAnything({@required DoAnything whatTodo}) {
    value=whatTodo(value);
    controller.sink.add(value);
  }

  void dispose() {
    controller.close();
  }

  Widget blocWidget({@required ValueChanged widget}) {
    return StreamBuilder<T>(
        initialData: value,
        stream: controller.stream,
        builder: (context, snapshot) {
          return widget(snapshot.data);
        });
  }
}

````

## How to Use

````

class _MyHomePageState extends State<MyHomePage> {
  BaseBloc<int> baseBloc;

  @override
  void initState() {
    super.initState();
    baseBloc = BaseBloc(0);
  }

  @override
  void dispose() {
    baseBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            baseBloc.blocWidget(widget: (value) {
              return Text(
                '$value',
                style: Theme.of(context).textTheme.display1,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          baseBloc.doAnything(whatTodo: (value) {
            value++;
            return value;
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),);
  }
}

````
