import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan import ini
import 'package:pkm_gastreit/screen/sign_in_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  String? _gender;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  Future<void> _signUp() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Coba mendaftar pengguna baru
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    User? user = userCredential.user;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).set({
        'fullName': _nameController.text,
        'phoneNumber': _phoneController.text,
        'email': user.email,
        'gender': _gender, // Menambahkan data jenis kelamin
      });

      // Tampilkan dialog setelah pendaftaran berhasil
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Berhasil'),
            content: Text('Pendaftaran berhasil! Silakan login.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  } on FirebaseAuthException catch (e) {
    // Tangani kesalahan jika email sudah digunakan
    if (e.code == 'email-already-in-use') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email Sudah Terdaftar'),
            content: Text(
                'Email yang Anda masukkan sudah digunakan oleh akun lain.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Tangani kesalahan lainnya
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.message ?? 'Terjadi kesalahan'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Register',
          style: GoogleFonts.ubuntu(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(10, 40, 116, 1)),
        ),
        backgroundColor: Color.fromRGBO(163, 183, 234, 1),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        'Selamat Datang di GASTREIT!',
                        style: GoogleFonts.murecho(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Daftar untuk melanjutkan',
                        style: GoogleFonts.ubuntu(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(10, 40, 116, 1),
                        ),
                      ),
                      SizedBox(height: 50),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              labelStyle: GoogleFonts.ubuntu(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(10, 40, 116, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama lengkap harus diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: 'Nomor Telepon',
                              labelStyle: GoogleFonts.ubuntu(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(10, 40, 116, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor telepon harus diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Jenis Kelamin',
                              labelStyle: GoogleFonts.ubuntu(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(10, 40, 116, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                            value: _gender,
                            items: [
                              DropdownMenuItem<String>(
                                value: 'Male',
                                child: Row(
                                  children: [
                                    Icon(Icons.male, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Laki-laki'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Female',
                                child: Row(
                                  children: [
                                    Icon(Icons.female, color: Colors.pink),
                                    SizedBox(width: 8),
                                    Text('Perempuan'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Jenis kelamin harus dipilih';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: GoogleFonts.ubuntu(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(10, 40, 116, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email harus diisi';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Masukkan email yang valid';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.ubuntu(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(10, 40, 116, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password harus diisi';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi Password',
                              labelStyle: GoogleFonts.ubuntu(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(10, 40, 116, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(217, 217, 217, 1),
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_confirmPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password harus diisi';
                              }
                              if (value != _passwordController.text) {
                                return 'Password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _signUp();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0A2874),
                                    minimumSize: Size(double.infinity, 55),
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
                          SizedBox(height: 40),
                          Text(
                            'GASTREIT',
                            style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'already have an account? ',
                            style: GoogleFonts.libreFranklin(fontSize: 15),
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                );
                              },
                              child: Text(
                                'LOGIN',
                                style: GoogleFonts.libreFranklin(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(8, 4, 180, 1)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
