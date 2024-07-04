// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pkm_gastreit/screen/home_screen.dart';
import 'package:pkm_gastreit/screen/input_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReportScreen(),
    );
  }
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InputScreen()),
        );
        break;
      case 2:
        
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Citra'),
        leadingWidth: 100, // Adjust the width to accommodate the Row content
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/home_light.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/input_light.png')),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/hasil_black.png')),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}