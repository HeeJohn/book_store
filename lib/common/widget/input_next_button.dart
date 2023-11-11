import 'package:db/common/custom_textform.dart';
import 'package:flutter/material.dart';
import 'next_button.dart';

class BottomField extends StatelessWidget {
  final String hintText;
  final String? errorText;
  final String buttonText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool hasError;
  final bool keyboardOn;
  const BottomField({
    super.key,
    required this.keyboardOn,
    required this.hintText,
    this.onChanged,
    required this.buttonText,
    required this.onPressed,
    required this.hasError,
    this.validator,
    this.keyboardType,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // height: keyboardOn ? 20.0 : 10.0,
            height: 15,
          ),
        ],
      ),
    );
  }
}
