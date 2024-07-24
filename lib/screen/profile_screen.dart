// lib/screen/profile_screen.dart

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:google_fonts/google_fonts.dart';
import 'change_password_screen.dart'; // Import the ChangePasswordScreen
import 'edit_profile_screen.dart'; // Import the EditProfileScreen
import 'package:pkm_gastreit/screen/sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  Future<Map<String, String>> _getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'fullName': 'N/A', 'phoneNumber': 'N/A'};
    }

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = userDoc.data() as Map<String, dynamic>;

    return {
      'fullName': data['fullName'] ?? 'N/A',
      'phoneNumber': data['phoneNumber'] ?? 'N/A',
    };
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('You have successfully signed out.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SignInScreen()), // Navigasi kembali ke layar login
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  final User? user = FirebaseAuth.instance.currentUser;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Profile',
        style: GoogleFonts.ubuntu(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color.fromRGBO(10, 40, 116, 1),
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            // Navigate to edit profile screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfileScreen()),
            );
          },
        ),
      ],
      iconTheme: IconThemeData(color: Colors.white), // Set back arrow color to white
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: FutureBuilder<Map<String, String>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data ?? {'fullName': 'N/A', 'phoneNumber': 'N/A'};

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Name: ${userData['fullName']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${user?.email ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone: ${userData['phoneNumber']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to change password screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: Text('Change Password'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _signOut(context), // Use the updated _signOut method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Button background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: Text('Sign Out'),
                ),
              ],
            );
          }
        },
      ),
    ),
  );
}
}
