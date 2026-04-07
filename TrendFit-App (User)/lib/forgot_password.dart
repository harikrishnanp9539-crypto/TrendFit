import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:trendfitapp/login.dart';
// import 'app_login.dart';

void main() {
  runApp(const forgotpassword());
}

class forgotpassword extends StatelessWidget {
  const forgotpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Forgot Password',
      home: forgot_password(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class forgot_password extends StatefulWidget {
  const forgot_password({super.key});

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  final TextEditingController email = TextEditingController();

  Future<void> sendData() async {
    String femail = email.text.trim();
    if (femail.isEmpty || !femail.contains('@')) {
      Fluttertoast.showToast(msg: 'Enter a valid email');
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    final urls = Uri.parse('$url/appforgotpassword_post/');

    try {
      final response = await http.post(urls, body: {
        'email': femail,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String status = data['status'];

        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Password sent to email');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Myloginpage(title: '',)),
          );
        } else {
          Fluttertoast.showToast(msg: 'Email not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Forgot password',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      'Enter your registered email address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: sendData,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 4,
                        ),
                        child: const Text(
                          'Send Password',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
