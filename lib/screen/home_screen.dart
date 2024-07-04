// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pkm_gastreit/screen/input_screen.dart';
import 'package:pkm_gastreit/screen/report_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Do nothing, since we are already on HomeScreen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InputScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: InwardAppBarClipper(),
            child: Container(
              height: 220,
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Hi, Lula\nWelcome back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Rekam Citra Medis'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CategoryButton(
                          image: Image.asset(
                            "images/Icon-InputCitra.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          label: 'Input Citra',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InputScreen(),
                              ),
                            );
                          },
                        ),
                        CategoryButton(
                          image: Image.asset(
                            "images/Icon-HasilCitra.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          label: 'Hasil Citra',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Informasi Menarik',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      'images/informasimenarik1.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Image.asset(
                                      'images/informasimenarik2.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/home_black.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/input_light.png')),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/hasil_light.png')),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final Image image;
  final String label;
  final VoidCallback onPressed;

  CategoryButton({required this.image, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.blue[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.all(20),
            side: BorderSide(color: Colors.blue, width: 2),
          ),
          child: Column(
            children: [
              image,
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 20, color: Colors.blue)),
            ],
          ),
        ),
      ],
    );
  }
}

class InwardAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height - 100);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
