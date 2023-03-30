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
