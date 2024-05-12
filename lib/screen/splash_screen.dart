import 'package:flutter/material.dart';
import 'package:pkm_gastreit/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Di sini Anda dapat menambahkan logika untuk menunggu beberapa detik sebelum
    // navigasi ke layar berikutnya, atau menyiapkan data awal jika diperlukan.
    // Contoh:
    Future.delayed(const Duration(seconds: 5), () {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) =>const LoginScreen()), // Replace 'NextScreen' with the correct method name or define a method named 'NextScreen'
    );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white], // Ubah warna sesuai kebutuhan
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar
              Image.asset(
                "images/logo.png", // Ganti dengan path gambar yang sesuai
                width: 200, // Atur lebar gambar sesuai kebutuhan
                height: 200, // Atur tinggi gambar sesuai kebutuhan
                fit: BoxFit.contain, // Atur fit sesuai kebutuhan
              ),
              const SizedBox(height: 10), // Spasi antara gambar dan teks
              // Teks
              const Text(
                'GASTREIT',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black,
                )
              ),
              const SizedBox(height: 15),
              const Text(
                'EARLY INSIGHT GERD OUT OF SIGHT', // Teks yang ingin ditampilkan
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 20, // Ukuran font teks
                  color: Color(0xFF041E60), // Warna teks
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}