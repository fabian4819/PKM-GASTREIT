import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('images/home_black.png')),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('images/input_black.png')),
          label: 'Input',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('images/hasil_black.png')),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('images/chat_black.png')),
          label: 'Chat',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    );
  }
}
