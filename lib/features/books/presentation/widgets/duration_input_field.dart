import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const DurationInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Duration',
        hintText: 'hh:mm',
        border: OutlineInputBorder(),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
        _TimeInputFormatter(),
      ],
      validator: validator,
    );
  }
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Remove any existing colons for processing
    String digitsOnly = text.replaceAll(':', '');

    // Limit to 4 digits (hhmm)
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    String formatted = '';
    if (digitsOnly.isNotEmpty) {
      // Add first digit or two (hours)
      if (digitsOnly.length >= 1) {
        formatted = digitsOnly.substring(0, digitsOnly.length >= 2 ? 2 : 1);
      }
      // Add colon and minutes
      if (digitsOnly.length > 2) {
        formatted += ':${digitsOnly.substring(2)}';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
