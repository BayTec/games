import 'package:flutter/material.dart';

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.icon,
    this.autofillHint,
    this.errorText,
  });

  final TextEditingController controller;
  final String label;
  final Widget? icon;
  final TextInputType keyboardType;
  final String? autofillHint;
  final bool obscure;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        autofillHints: autofillHint != null ? [autofillHint!] : null,
        decoration: InputDecoration(
            label: Text(label),
            border: const OutlineInputBorder(),
            prefixIcon: icon,
            errorText: errorText),
      ),
    );
  }
}
