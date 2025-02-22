import 'package:colornestle/pages/color_details_page.dart';
import 'package:colornestle/pages/login_screen.dart';
import 'package:colornestle/pages/navpages/main_page.dart';
import 'package:colornestle/pages/register.dart';
import 'package:colornestle/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pages/p2pVideo.dart';
import 'state/room_cubit.dart';
import 'pages/color_matcher.dart';
import 'pages/feedback_page.dart';
import 'pages/forgot_password.dart';
import 'pages/history_page.dart';
import 'pages/navpages/generate_image.dart';
import 'pages/panorama_screen.dart';
import 'pages/panoramic_view.dart';
import 'pages/preference_form.dart';
import 'screen/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomCubit()..fetchImages('all', 'all', 'all'),
      child: MaterialApp(
        title: 'ColorNestle',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const Splashscreen(),
          '/welcome': (context) => const Welcome(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MainPage(),
          '/details': (context) => const ColorDetailsPage(),
          '/visualize': (context) => const GenerateImage(),
          '/panoramacapture': (context) => const PanoramaScreen(),
          '/preferenceform': (context) => const UserPreferenceForm(),
          '/colormatcher': (context) => const ColorMatcher(),
          '/P2PVideo': (context) => const P2PVideo(),
          '/history': (context) => const HistoryPage(),
          '/feedback': (context) => const FeedbackPage(),
          '/forgot_password': (context) => const ForgotPasswordPage(),
          '/objectmarking': (context) => PhotoMarkingApp(),
        },
      ),
    );
  }
}
