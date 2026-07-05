import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppColors.mediumGray),
        prefixIcon: Icon(icon, color: AppColors.electricBlue, size: 20),
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 12),
          child: Text(
            'MW',
            style: TextStyle(
              color: AppColors.mediumGray,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}
