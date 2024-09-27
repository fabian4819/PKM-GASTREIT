import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:pkm_gastreit/screen/sign_in_screen.dart'; // Import halaman Sign In
import 'package:pkm_gastreit/screen/sign_up_screen.dart'; // Import halaman Sign Up
import 'package:pkm_gastreit/screen/role_selection_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPageIndex < 2) {
        _currentPageIndex++;
      } else {
        _currentPageIndex = 0;
      }

      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  //Dan Seterusnya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Image.asset(
                        "images/landing_1.png",
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Selamat Datang di GASTREIT',
                        style: GoogleFonts.murecho(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        Image.asset(
                          "images/landing_2.png",
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Gejala Umum Masalah',
                          style: GoogleFonts.murecho(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Lambung',
                          style: GoogleFonts.murecho(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Image.asset(
                        "images/landing_3.png",
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tips Menjaga Kesehatan',
                        style: GoogleFonts.murecho(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          'Lambung',
                          style: GoogleFonts.murecho(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _currentPageIndex == index
                        ? Color.fromARGB(255, 6, 26, 76)
                        : Color(0xFFA3B7EA),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A2874),
                    minimumSize: Size(304, 50),
                  ),
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.libreFranklin(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(151, 151, 151, 1),
                    minimumSize: Size(304, 50),
                  ),
                  child: Text(
                    'REGISTER',
                    style: GoogleFonts.libreFranklin(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LandingScreen(),
  ));
}
