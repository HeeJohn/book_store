import 'package:db/activity/common/bottom_nav.dart';
import 'package:db/activity/meet_up_list_screen.dart';
import 'package:db/activity/notification_screen.dart';
import 'package:db/activity/register_screen.dart';
import 'package:db/activity/search_screen.dart';
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
    MeetUpList(),
    NotificationScreen(),
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
