import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomDesign extends StatelessWidget {
  final void Function(int)? onTabChange;
  const BottomDesign({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      child: GNav(
        onTabChange: (value) => onTabChange!(value),
        tabBackgroundColor: Colors.black,
        color: Colors.grey[600],
        activeColor: Colors.white,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        tabs: const [
          GButton(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            icon: Icons.search,
            text: "Search",
            gap: 8,
          ),
          GButton(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            icon: Icons.menu_book,
            text: "Register",
            gap: 8,
          ),
          GButton(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            icon: Icons.map_outlined,
            text: "meet up",
            gap: 8,
          )
        ],
      ),
    );
  }
}
