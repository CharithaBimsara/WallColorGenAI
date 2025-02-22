import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async'; // Import for Timer
import '../utils/database_check.dart';
import 'welcome.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  String? _errorMessage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _showToast('Loading...');
    _startPeriodicChecks();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicChecks() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      bool checksPassed = await _performChecks();
      if (checksPassed) {
        timer.cancel();
        Navigator.of(context).pushReplacement(_createRoute());
      } else {
        setState(() {
          _errorMessage = 'Initialization failed. Please check your connection and try again.';
        });
        _showToast(_errorMessage!);
      }
    });
  }

  Future<bool> _performChecks() async {
    if (!(await checkNetworkConnection(context))) {
      setState(() {
        _errorMessage = 'No network connection';
      });
      _showToast(_errorMessage!);
      return false;
    }
    if (!(await checkDatabaseDriver(context))) {
      setState(() {
        _errorMessage = 'Database driver check failed';
      });
      _showToast(_errorMessage!);
      return false;
    }
    if (!(await checkDatabaseConnection(context))) {
      setState(() {
        _errorMessage = 'Database connection check failed';
      });
      _showToast(_errorMessage!);
      return false;
    }
    return true;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Welcome(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(seconds: 2), // Slow down the fade transition
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: LottieBuilder.asset(
              "assets/Lottie/u14rjfxjVU.json",
              frameRate: FrameRate.max,
              fit: BoxFit.cover, // Ensure the animation covers the full screen
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 59, 42, 42),
    );
  }
}
