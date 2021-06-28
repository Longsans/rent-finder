import 'package:flutter/material.dart';

class DecoratedTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String errorText;

  DecoratedTextField(
      {Key key, @required this.controller, this.hintText = '', this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: TextStyle(fontSize: 14, height: 1.5),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black87, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1)),
        errorText: errorText,
      ),
    );
  }
}
