import 'package:db/common/custom_textform.dart';
import 'package:db/common/widget/next_button.dart';
import 'package:flutter/material.dart';

class BottmFieldRequest extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? errorText;
  final FocusNode phoneNumberFocusNode;
  final VoidCallback onNextPressed;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool hasError;
  final bool keyboardOn;
  const BottmFieldRequest({
    super.key,
    required this.keyboardOn,
    required this.hasError,
    required this.onChanged,
    required this.errorText,
    required this.phoneNumberFocusNode,
    required this.onNextPressed,
    required this.hintText,
    required this.validator,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            hasError: hasError,
            keyboardType: keyboardType,
            onChanged: onChanged,
            hintText: hintText,
            autofocus: true,
            errorText: errorText,
            validator: validator,
          ),
          const SizedBox(
            // height: keyboardOn ? 20.0 : 10.0,
            height: 20,
          ),
          NextButton(
            buttonText: 'Continue',
            onPressed: onNextPressed, //validatonCheck,
          ),
        ],
      ),
    );
  }
}
