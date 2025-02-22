import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';
import 'login_screen.dart';
import 'package:crypto/crypto.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _resetPassword() async {
    final code = _codeController.text;
    final password = _passwordController.text;
    final hashedPassword = hashPassword(password);
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password mismatch')),
        );
      }
      return;
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/auth/reset-password'),
      body: {
        'email': widget.email,
        'code': code,
        'password': hashedPassword,
      },
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successfully')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to login page
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }

  Future<void> _sendForgotPasswordEmail() async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/v1/auth/forgot-password'),
      body: {'email': widget.email},
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check your email for the new password reset code'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${response.body}'),
        ),
      );
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var digest = sha256.convert(bytes); // Hash the password using SHA-256
    return digest.toString(); // Convert the digest to a string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/forgot_password');
          },
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: "Lato",
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter your verification code",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: 'Reset Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
            
                  TextButton(
                    onPressed: _sendForgotPasswordEmail,
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
            
                  
                  Text(
                    "Sign up your Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: _resetPassword,
                    borderRadius: BorderRadius.circular(50),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        child: Text(
                          'RESET PASSWORD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
