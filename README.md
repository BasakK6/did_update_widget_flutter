# did_update_widget_flutter

Using the lifecycle methods of a StatefulWidget properly is of great importance when it comes to Flutter apps.
In this project, we will explore when & how to use the **didUpdateWidget** lifecycle method.

A Stateful Widget can receive an argument via its constructor. 
Then, this argument can be accessed with the "widget" property of the State class.

If the parent widget passes its state objects to the child StatefulWidget via its constructor,
then the child widget can learn the changes in the parent's state with the help of the **didUpdateWidget** lifecycle method.

Flutter documentation describes the **didUpdateWidget** method like this:
> If you wish to be notified when the widget property changes, override the didUpdateWidget() function, which is passed an oldWidget to let you compare the old widget with the current widget.

> Parent widget might rebuild and request that the
location in the tree update to display a new widget with the same
[runtimeType] and [Widget.key]. When this happens, the framework will
update the [widget] property to refer to the new widget and then call the
[didUpdateWidget] method with the previous widget as an argument. [State]
objects should override [didUpdateWidget] to respond to changes in their
associated widget (e.g., to start implicit animations). 


In this project, we will build an application that has a StatefulWidget that controls its own state but also rebuilds itself when the parent widget's state changes.

Our app will look like this at the end:

<img src="https://github.com/BasakK6/did_update_widget_flutter/blob/master/readme_assets/andorid_screen_recording.gif?raw=true" alt="UI screen recording" width="250"/>

The square-shaped and colored container will be the child widget and use didUpdateWidget to be notified when the parent widget changes its state via its "Toggle Background Color (pink)" button.

## 1) Parent Widget

Let's say we have a StatefulWidget called **MyHomePage** and it is the main route of our application

```dart
import 'package:did_update_widget_flutter/my_home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
```

In MyHomePage we have a variable named **_backgroundColor** that is passed to a child widget called **InnerWidget**. We have a method named **setBackgroundColorToPink()** that uses **setState** on **_backgroundColor** and assignes a pink shade to the **_backgroundColor**. 
This method is called whenever the ElevatedButton is clicked. 
In this example, we want to reflect the changes in the **_backgroundColor** to the InnerWidget.

```dart
import 'package:did_update_widget_flutter/inner_widget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color? _backgroundColor;

  final pinkShade200 = Colors.pink[200];
  final pinkShade400 = Colors.pink[400];

  void setBackgroundColorToPink() {
    setState(() {
      if (_backgroundColor == pinkShade200) {
        _backgroundColor = pinkShade400;
      } else {
        _backgroundColor = pinkShade200;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("didUpdateWidget usage"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: setBackgroundColorToPink,
              child: const Text("Toggle Background Color (pink)"),
            ),
            const SizedBox(
              height: 32,
            ),
            InnerWidget(initialColor: _backgroundColor),
          ],
        ),
      ),
    );
  }
}
```

## 2) Child Widget

InnerWidget is a StatefulWidget that has a property named **initialColor**. 
This property is accessed with **"widget.initialColor"** in the state object.

InnerWidget's state object also has a variable called **_backgroundColor** but this time **_backgroundColor** color is changed to a green shade with **toggleBackgroundColor()** method.
This method is called when the elevated button inside the InnerWidget is pressed. 


```dart
import 'package:flutter/material.dart';

class InnerWidget extends StatefulWidget {
  const InnerWidget({Key? key, required this.initialColor}) : super(key: key);

  final Color? initialColor;

  @override
  State<InnerWidget> createState() => _InnerWidgetState();
}

class _InnerWidgetState extends State<InnerWidget> {
  Color? _backgroundColor;

  final greenShade200 = Colors.green[200];
  final greenShade400 = Colors.green[400];

  @override
  void initState() {
    super.initState();
    _backgroundColor = widget.initialColor ?? greenShade200;
  }

  void toggleBackgroundColor() {
    setState(() {
      if (_backgroundColor == greenShade200) {
        _backgroundColor = greenShade400;
      } else {
        _backgroundColor = greenShade200;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: _backgroundColor,
      width: 300,
      height: 300,
      child: ElevatedButton(
        onPressed: toggleBackgroundColor,
        child: const Text("Toggle Background Color (green)"),
      ),
    );
  }
}
```

So far, we can change the state of the InnerWidget and receive the parent widget's state via initialColor parameter. 
But we don't actually use it because when the InnerWidget is created "initialColor" is null.

So how can we learn about the changes in the parent widget? We can simply override the **didUpdateWidget** and compare the old configuration of the InnerWidget with the new.

When the parent widget gets rebuilt a new StatefulWidget called InnerWidget will be created since StatefulWidgets are immutable. 
After that, the new widget will be associated with the same State object and the didUpdateWidget method will be triggered. 
didUpadeteWidget provides us with the old configuration of the InnerWidget with a parameter named oldWidget. 
In this method, we can check if the initialColor is changed and if so we can assign the new color to the _backgroundColor variable of the InnerWidgret.
After this assignment, we do not need the call the setState because:

> The framework  always calls [build] after calling [didUpdateWidget], which means any
calls to [setState] in [didUpdateWidget] are redundant.


```dart
@override
void didUpdateWidget(covariant InnerWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  //compare the old and the new
  if (oldWidget.initialColor != widget.initialColor) {
    _backgroundColor = widget.initialColor;
  }
}
```


## 3) Complete code of the InnerWidget

```dart
import 'package:flutter/material.dart';

class InnerWidget extends StatefulWidget {
  const InnerWidget({Key? key, required this.initialColor}) : super(key: key);

  final Color? initialColor;

  @override
  State<InnerWidget> createState() => _InnerWidgetState();
}

class _InnerWidgetState extends State<InnerWidget> {
  Color? _backgroundColor;

  final greenShade200 = Colors.green[200];
  final greenShade400 = Colors.green[400];

  @override
  void initState() {
    super.initState();
    _backgroundColor = widget.initialColor ?? greenShade200;
  }

  @override
  void didUpdateWidget(covariant InnerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    //compare the old and the new
    if (oldWidget.initialColor != widget.initialColor) {
      _backgroundColor = widget.initialColor;
    }
  }

  void toggleBackgroundColor() {
    setState(() {
      if (_backgroundColor == greenShade200) {
        _backgroundColor = greenShade400;
      } else {
        _backgroundColor = greenShade200;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: _backgroundColor,
      width: 300,
      height: 300,
      child: ElevatedButton(
        onPressed: toggleBackgroundColor,
        child: const Text("Toggle Background Color (green)"),
      ),
    );
  }
}
```
