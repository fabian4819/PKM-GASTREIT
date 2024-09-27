// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pkm_gastreit/screen/landing_screen.dart';
import 'package:pkm_gastreit/screen/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<String> _versionFuture;

  @override
  void initState() {
    super.initState();
    _versionFuture = _getVersion();
    _checkAuthAndNavigate(); // Cek status autentikasi dan navigasi
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3)); // Durasi Splash Screen

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Jika user sudah login, arahkan ke HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Jika user belum login, arahkan ke LandingScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LandingScreen()),
      );
    }
  }
  //Dan Seterusnya
  Future<String> _getVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      print('App Version: ${packageInfo.version}');
      return packageInfo.version;
    } catch (e) {
      print('Failed to get version: $e');
      return 'Unknown';
    }
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo.png",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                'GASTREIT',
                style: GoogleFonts.ubuntu(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'EARLY INSIGHT GERD OUT OF SIGHT',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF041E60),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: _versionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading version...',
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF041E60),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error loading version',
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF041E60),
                      ),
                    );
                  } else {
                    return Text(
                      'Versi: ${snapshot.data}',
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF041E60),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
