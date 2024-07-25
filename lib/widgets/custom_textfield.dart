// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.hint,
    this.prefix,
    required this.controller,
    this.label,
    this.inputType = TextInputType.text,
    this.obscure = false,
    this.padding = 0,
    this.inputFormatter,
  });

  final String hint;
  final Widget? prefix;
  final TextEditingController controller;
  final String? label;
  final TextInputType inputType;
  final bool obscure;
  final double padding;
  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Tolong $hint";
          }
          return null;
        },
        obscureText: obscure,
        keyboardType: inputType,
        controller: controller,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            prefixIcon: prefix,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]!),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.deepPurple)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[400]!)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red))),
      ),
    );
  }
}
