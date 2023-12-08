import 'package:flutter/material.dart';

class StateSlider extends StatefulWidget {
  final String label;
  final Function(double) pollValue;
  const StateSlider({
    super.key,
    required this.label,
    required this.pollValue,
  });

  @override
  State<StateSlider> createState() => _StateSliderState();
}

class _StateSliderState extends State<StateSlider> {
  double? value;

  @override
  void initState() {
    value = 1.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          divisions: 2,
          value: value!,
          min: 1,
          max: 3,
          onChanged: (val) {
            setState(() {
              value = val;
              widget.pollValue(val);
              print("from slider : $val");
            });
          },
          label: value == 1 ? '나쁨' : (value == 2 ? '보통' : '좋음'),
        ),
      ],
    );
  }
}
