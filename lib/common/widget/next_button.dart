import 'package:db/common/const/color.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.buttonText,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1 / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: grey,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 35, 35, 35),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
