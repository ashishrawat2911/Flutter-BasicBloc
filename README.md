# Simple Bloc


## Base Bloc


````
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
````

##How to Use

````

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  BaseBloc<int> baseBloc;

  void _incrementCounter() {
    baseBloc.doAnything(whatTodo: () {
      _counter++;
      return _counter;
    });
  }

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
            baseBloc.blocWidget(widget: (snapshot) {
              return Text(
                '${snapshot.data}',
                style: Theme.of(context).textTheme.display1,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

````