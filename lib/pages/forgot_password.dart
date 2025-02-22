import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';
import 'reset_password.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

 Future<void> _sendForgotPasswordEmail() async {
  final email = _emailController.text;
  final response = await http.post(
    Uri.parse('${Config.baseUrl}/api/auth/forgot-password'),
    body: {'email': email},
  );

  if (!mounted) return;

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Check your email for the new password reset code'),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordPage(email: email),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/login');
          },
        ),
        title: Text(
          'Verification',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Your email to send the password\nreset code",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Enter Your email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'charitha@gmail.com',
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
                SizedBox(height: 50),
                InkWell(
                  onTap: _sendForgotPasswordEmail,
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
                        'Send Email',
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
    );
  }
}
