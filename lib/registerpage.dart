import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  // Validasi username
  String? validateUsername(String value) {
    // Tambahkan aturan validasi sesuai kebutuhan
    if (value.isEmpty) {
      return 'Username tidak boleh kosong.';
    } else if (value.length < 6) {
      return 'Username harus terdiri dari minimal 6 karakter.';
    }
    return null;
  }

  // Fungsi untuk melakukan registrasi dengan Firebase
  Future<void> _registerWithFirebase() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text.trim(), // Gunakan email sebagai username
        password: _passwordController.text,
      );

      // Registrasi berhasil, simpan data ke Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', _usernameController.text.trim());
      prefs.setBool('isChecked', _isChecked);

      // Kembali ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        // Tampilkan pesan kesalahan jika password lemah
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        // Tampilkan pesan kesalahan jika email sudah digunakan
      }
      // Dan lain-lain, sesuai kebutuhan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message ?? "Registration failed."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        title: Text(
          "Me Apps - Register",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Selamat Datang
            Text(
              "Selamat Datang ke Me Apps",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Label "Username"
            Text(
              "Username",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Textbox untuk mengisi username
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan username',
                  errorText: validateUsername(_usernameController.text),
                ),
              ),
            ),

            // Label "Password"
            Text(
              "Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Textbox untuk mengisi password
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan password (min. 8 karakter)',
                  errorText: _passwordController.text.length >= 8
                      ? null
                      : 'Password harus terdiri dari minimal 8 karakter',
                ),
              ),
            ),

            // Label "Confirm Password"
            Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Textbox untuk mengisi confirm password
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan kembali password',
                  errorText: _passwordController.text == _confirmPasswordController.text
                      ? null
                      : 'Password dan Confirm Password harus sama',
                ),
              ),
            ),

            // Checkbox "Saya Menyetujui Persyaratan"
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                Text(
                  "Saya Menyetujui Persyaratan yang ada",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),

            // Tombol Register
            ElevatedButton(
              onPressed: () {
                String? usernameError = validateUsername(_usernameController.text);

                if (usernameError != null) {
                  // Tampilkan pesan kesalahan jika username tidak sesuai ketentuan
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text(usernameError),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else if (_passwordController.text.isEmpty || _passwordController.text.length < 8) {
                  // ... (validasi password tetap sama)
                } else if (_confirmPasswordController.text.isEmpty || _passwordController.text != _confirmPasswordController.text) {
                  // ... (validasi konfirmasi password tetap sama)
                } else if (!_isChecked) {
                  // ... (validasi checkbox tetap sama)
                } else {
                  // Registrasi dengan Firebase
                  _registerWithFirebase();
                }
              },
              child: Text("Register"),
            ),

            // Link ke LoginPage
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                "Sudah memiliki akun? Login di sini",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
