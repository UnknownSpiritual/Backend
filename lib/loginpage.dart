import 'package:flutter/material.dart';
import 'package:uts_2/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isChecked = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  _loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _isChecked = prefs.getBool('isChecked') ?? false;
    });
  }

  _saveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setBool('isChecked', _isChecked);
  }

  bool _isPasswordValid() {
    return _passwordController.text.length > 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        title: const Text(
          "Me Apps",
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
            // CircleAvatar untuk menampilkan gambar dari URL
            const CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey, // Ganti dengan warna atau gambar yang diinginkan
              backgroundImage: NetworkImage('https://media.istockphoto.com/id/860586342/id/vektor/ilustrasi-vektor-kartun-konsep-breaking-news-koresponden-dengan-mikrofon-reporter-berita.jpg?s=1024x1024&w=is&k=20&c=vdyx76y7UWBxp-mHwkvqqofMkuYr1MQFtvt9bfCMW4U='),
            ),
            const SizedBox(height: 20),

            // Label "Username"
            const Text(
              "Username",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Textbox untuk mengisi username
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _usernameController,
                onChanged: (value) => _saveValues(),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan username',
                ),
              ),
            ),

            // Label "Password"
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Textbox untuk mengisi password
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _passwordController,
                onChanged: (value) => _saveValues(),
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: const OutlineInputBorder(),
                  hintText: 'Masukkan password (min. 8 karakter)',
                  errorText: _isPasswordValid() ? null : 'Password harus lebih dari 8 karakter',
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
                      _saveValues();
                    });
                  },
                ),
                const Text(
                  "Saya Menyetujui Persyaratan yang ada",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),

            // Tombol Login
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika login di sini
                if (_isPasswordValid() && _isChecked) {
                  // Simpan username dan password saat login berhasil
                  _saveValues();
                } else {
                  // Tampilkan pesan kesalahan jika password tidak valid atau checkbox belum dicentang
                  String errorMessage = '';
                  if (!_isPasswordValid()) {
                    errorMessage = 'Password harus lebih dari 8 karakter.';
                  }
                  if (!_isChecked) {
                    errorMessage += '\nCheckbox harus dicentang.';
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Error"),
                        content: Text(errorMessage),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text("Login"),
            ),

            // Link ke halaman register
            TextButton(
              onPressed: () {
                // Navigasi ke halaman register
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text("Belum punya akun? Register di sini"),
            ),
          ],
        ),
      ),
    );
  }
}

