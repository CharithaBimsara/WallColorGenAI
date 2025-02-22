import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/login_screen.dart';
import '../pages/register.dart';


class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  void _navigateToLogin() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (!mounted) return; // Ensure the widget is still mounted
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToRegister() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (!mounted) return; // Ensure the widget is still mounted
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo3 (Small).png",
                scale: 0.50,
              ),
              Transform.translate(
                offset: Offset(0, -60),
                
              ),
              
              const SizedBox(height: 20),
              InkWell(
                splashColor: Colors.green,
                borderRadius: BorderRadius.circular(50),
                onTap: _navigateToLogin, // Directly call the method
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 51,
                    width: 319,
                    child: const Center(
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: _navigateToRegister, // Directly call the method
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 51,
                    width: 319,
                    child: const Center(
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: const Text(
                  "Connect with Social Media",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/dashboard',
                        arguments: {
                          'name': 'User',
                          'email': 'user@example.com',
                        },
                      );
                    },
                    icon: FaIcon(FontAwesomeIcons.instagram),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.facebook),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.xTwitter,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
