import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  const FormWidget(
      {super.key,
      required this.label,
      this.obscure = false,
      required this.controllerText,
      this.textType = TextInputType.text});

  final String label;
  final bool obscure;
  final TextEditingController controllerText;
  final TextInputType textType;

  @override
  Widget build(BuildContext context) {
    Color colorG = const Color.fromARGB(255, 102, 206, 105);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        cursorColor: colorG,
        style: TextStyle(color: colorG),
        controller: controllerText,
        obscureText: obscure,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: colorG),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: colorG)),
            border: const OutlineInputBorder(),
            labelText: label),
      ),
    );
  }
}
