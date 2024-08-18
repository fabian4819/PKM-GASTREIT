// role_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_up_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Peran',
          style: GoogleFonts.libreFranklin(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF0A2874),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Daftar Sebagai',
              style: GoogleFonts.libreFranklin(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2874),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A2874),
                minimumSize: Size(double.infinity, 60),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              icon: Icon(Icons.medical_services, color: Colors.white),
              label: Text(
                'Register as Doctor',
                style: GoogleFonts.libreFranklin(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0A2874),
                minimumSize: Size(double.infinity, 60),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              icon: Icon(Icons.person, color: Colors.white),
              label: Text(
                'Register as Patient',
                style: GoogleFonts.libreFranklin(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
