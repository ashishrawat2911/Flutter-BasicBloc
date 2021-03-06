# Simple Bloc


## Base Bloc


````
import 'dart:async';

import 'package:flutter/material.dart';

typedef OnWidgetStateChanged<T> = Widget Function(T value);

typedef ChangeState<T> = T Function(T value);
typedef ListenToState<T> = void Function(T value);

/*
    Define a [BaseStateBloc]

    Example :
    BaseStateBloc<int> baseStateBloc=BaseStateBloc<int>();


*/

class BaseStateBloc<T> {
  T _value;
  StreamController<T> controller = StreamController<T>.broadcast();

  BaseStateBloc(T initialData) {
    this._value = initialData;
  }

  /*
   baseStateBloc.changeState(state: (value) {

        //do somthing with value

        return value;

      });

  });
  */

  changeState({@required ChangeState<T> state}) {
    _value = state(_value);
    controller.sink.add(_value);
  }

  /*
  baseStateBloc.changeStateWithoutValueProvided(value);
  */

  changeStateWithoutValueProvided(T value) {
    _value = value;
//    print(_value);
    controller.sink.add(_value);
  }

  //This will return a current value that is stored in this class
  T get value => _value;

  /*

  This requires to return a widget , whenever there is any change in the value of the bloc this method will update the state of the widget with new value

  baseStateBloc.blocWidget(widget: (value) {

  return Text("$value");

  });

  */

  Widget blocWidget({@required OnWidgetStateChanged<T> widget}) {
    return StreamBuilder<T>(
      initialData: _value,
      stream: controller.stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        return widget(snapshot.data);
      },
    );
  }

  listenToValue({@required ListenToState<T> listenToValue}) {
    print("sdf");
    controller.stream.listen((T data) {
      listenToValue(data);
    });
  }

  void dispose() {
    controller.close();
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
