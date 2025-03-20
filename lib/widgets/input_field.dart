import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const InputField({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          maxLength: 6,
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter number or spell',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.length == 6) {
              onSubmitted(value);
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
