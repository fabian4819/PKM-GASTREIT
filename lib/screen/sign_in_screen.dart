// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pkm_gastreit/screen/sign_up_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100, // Adjust the width to accommodate the Row content
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Flexible(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Back',
                  style: GoogleFonts.murecho(
                      fontSize: 15, fontWeight: FontWeight.bold),
                  overflow:
                      TextOverflow.ellipsis, // Ensure text does not overflow
                ),
              ),
            ),
          ],
        ),

        backgroundColor: Color.fromRGBO(163, 183, 234, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Selamat Datang di GASTREIT!',
              style: GoogleFonts.murecho(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Masuk untuk melanjutkan',
              style: GoogleFonts.ubuntu(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(10, 40, 116, 1)),
            ),
            SizedBox(height: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Mengatur input field menjadi berbentuk oval
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 2.0)),
                    filled: true,
                    fillColor: Color.fromRGBO(217, 217, 217, 1),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0), // Mengurangi panjang input field
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Mengatur input field menjadi berbentuk oval
                        borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            width: 2.0)),
                    filled: true,
                    fillColor: Color.fromRGBO(217, 217, 217, 1),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0), // Mengurangi panjang input field
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A2874),
                    minimumSize: Size(500, 55),
                  ),
                  child: Text(
                    'SIGN IN',
                    style: GoogleFonts.libreFranklin(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            //GOOGLE
            //FILL THIS
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Belum punya akun? ',
                style: GoogleFonts.libreFranklin(fontSize: 15),),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                    },
                    child: Text(
                      'SIGN UP',
                      style: GoogleFonts.libreFranklin(
                          fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(8, 4, 180, 1)),
                    ),
                  ),
                ),
                // GestureDetector(
                //   child: TextButton(),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => SignUpScreen()),
                //     );
                //   },
                //   child: Text(
                //     'SIGN UP',
                //     style: TextStyle(
                //       color: Colors.blue,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
