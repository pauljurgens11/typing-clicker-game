import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomKeyboardListener extends StatefulWidget {
  final Widget child;
  final Function letterEnteredFunction;

  const CustomKeyboardListener(
      {super.key, required this.child, required this.letterEnteredFunction});

  @override
  CustomKeyboardListenerState createState() => CustomKeyboardListenerState();
}

class CustomKeyboardListenerState extends State<CustomKeyboardListener> {
  late String keyPressed;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          final logicalKey = event.logicalKey;
          widget.letterEnteredFunction(logicalKey.keyLabel.toLowerCase());
        }
      },
      child: widget.child,
    );
  }
}
