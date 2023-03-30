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
