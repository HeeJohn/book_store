import 'package:flutter/material.dart';

class StateSlider extends StatelessWidget {
  final String label;
  final void Function(double)? onSliderChanged;
  final double value;
  const StateSlider({
    super.key,
    required this.value,
    required this.onSliderChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          divisions: 2,
          value: value,
          min: 1,
          max: 3,
          onChanged: onSliderChanged,
          label: value == 1 ? '나쁨' : (value == 2 ? '보통' : '좋음'),
        ),
      ],
    );
  }
}
