import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl; // Use this for AssetImage paths as well

  InformationScreen({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.ubuntu(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                child: imageUrl.startsWith('http') || imageUrl.startsWith('https')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 150, // Adjust the height as needed
                        
                      )
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 150, // Adjust the height as needed
                        
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: GoogleFonts.ubuntu(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                description,
                style: GoogleFonts.ubuntu(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
