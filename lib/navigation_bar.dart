import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _barColor = Color(0xFF2F3A4B); // same dark bar you used

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: _barColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded), label: 'Category'),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded), label: 'Request'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded), label: 'Request List'),
      ],
    );
  }
}
