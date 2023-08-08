import 'package:flutter/material.dart';
import 'package:games/component/outlined_text_field.dart';

class TextFormFieldDialog extends StatelessWidget {
  TextFormFieldDialog({
    super.key,
    required this.onSubmit,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.icon,
  }) : _controller = TextEditingController();

  final String label;
  final void Function(String)? onSubmit;
  final TextEditingController _controller;
  final TextInputType keyboardType;
  final bool obscure;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedTextField(
                controller: _controller,
                label: label,
                keyboardType: keyboardType,
                obscure: obscure,
                icon: icon,
              ),
              const SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: onSubmit != null
                        ? () {
                            onSubmit!(_controller.text);
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text('Submit'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
