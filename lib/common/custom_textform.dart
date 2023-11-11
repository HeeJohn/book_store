import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final bool hasError;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;
  final TextEditingController? textEditingController;

  // Constructor for a login-style form field
  const CustomTextFormField({
    super.key,
    required this.hasError,
    this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.validator,
    this.focusNode,
    this.keyboardType,
    this.prefixIcon,
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10),
    );

    return TextFormField(
      controller: textEditingController,
      style: const TextStyle(fontSize: 20.0),
      keyboardType: keyboardType,
      enableSuggestions: true,
      validator: validator,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      cursorHeight: 20,
      cursorColor: Colors.black,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIconColor: hasError ? Colors.red : Colors.blue,
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.fromLTRB(10, 20, 15, 20),
        hintText: hintText,
        errorText: errorText,
        errorStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
        fillColor: Colors.white,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            width: 2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
