import 'package:flutter/widgets.dart';

class TopImage extends StatelessWidget {
  const TopImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'asset/img/reading.png',
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 1 / 2,
    );
  }
}
