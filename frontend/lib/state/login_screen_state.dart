import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../utils/config.dart';
import '../widgets/toast.dart';

class LoginScreenState extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isEmailValid = ValueNotifier<bool>(true);

  bool obscurePassword = true;
  bool isLoading = false;
  String errorMessage = '';

  LoginScreenState() {
    emailController.addListener(_validateEmail);
    
  }

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void _validateEmail() {
    final email = emailController.text;
    isEmailValid.value = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var digest = sha256.convert(bytes); // Hash the password using SHA-256
    return digest.toString(); // Convert the digest to a string
  }

  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    showLoadingDialog();

    final hashedPassword = hashPassword(passwordController.text);
    final url = Uri.parse(
        '${Config.baseUrl}/api/client/getClientByClientEmailAndPassword/${emailController.text}/$hashedPassword');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String name = '${responseData['fname']} ${responseData['lname']}';
        final String email = responseData['email'];

        isLoading = false;
        notifyListeners();
        Navigator.of(formKey.currentContext!).pop();
         ToastUtils.showSuccessToast('Login Successful');

        clearInputFields();

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(
            formKey.currentContext!,
            '/home',
            arguments: {
              'name': name,
              'email': email,
            },
          );
        });
      } else {
        errorMessage = 'Invalid email or password';
        isLoading = false;
        notifyListeners();
        Navigator.of(formKey.currentContext!).pop();
        ToastUtils.showErrorToast(errorMessage);
      }
    } catch (e) {
      errorMessage = 'Invalid email or password';
      isLoading = false;
      notifyListeners();
      Navigator.of(formKey.currentContext!).pop();
      ToastUtils.showErrorToast(errorMessage);
    }
  }

  void clearInputFields() {
    emailController.clear();
    passwordController.clear();
  }

  void showLoadingDialog() {
    showDialog(
      context: formKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: double.infinity,
            height: 100,
            color: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                strokeWidth: 4.0,
              ),
            ),
          ),
        );
      },
    );
  }

  void showLoginSuccessDialog(String message) {
    showDialog(
      context: formKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.infinity,
            height: 250,
            color: Colors.white,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: formKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.infinity,
            height: 100,
            color: Colors.white,
            child: Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          ),
        );
      },
    );
  }
}
