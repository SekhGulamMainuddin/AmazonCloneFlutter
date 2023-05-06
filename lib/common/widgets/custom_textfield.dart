import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final bool isPassword;

  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.maxLines = 1,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black38,
        )),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
      ),
      obscureText: isPassword,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Enter the $hint";
        }
        return null;
      },
      maxLines: maxLines,
    );
  }
}
