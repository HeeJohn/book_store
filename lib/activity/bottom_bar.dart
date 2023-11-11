import 'package:db/activity/common/bottom_nav.dart';
import 'package:db/activity/meet_up.dart';
import 'package:db/activity/register.dart';
import 'package:db/activity/search.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> pages = const [
    SearchScreen(),
    RegisterScreen(),
    MeetUpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomDesign(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: pages[selectedIndex],
    );
  }
}
