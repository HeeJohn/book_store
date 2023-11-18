import 'package:db/home/common/layout.dart';
import 'package:db/home/common/top_image.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      children: [
        Expanded(
          child: TopImage(),
        )
      ],
    );
  }
}
