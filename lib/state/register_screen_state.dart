import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:crypto/crypto.dart';


import '../utils/config.dart';
import '../utils/database_check.dart';

class RegisterScreenState extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;
  String errorMessage = '';

  bool isfNameValid = true;
  bool islNameValid = true;
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;
  bool isEmailAlreadyExists = false;
  bool isBirthdayValid = true;
  String gender = 'Male';

  Timer? _debounce;

  RegisterScreenState() {
    fNameController.addListener(() => validatefName(fNameController.text));
    lNameController.addListener(() => validatelName(lNameController.text));
    emailController.addListener(() => _onEmailChanged(emailController.text));
    passwordController.addListener(() => validatePassword(passwordController.text));
    confirmPasswordController.addListener(() => validateConfirmPassword(confirmPasswordController.text));
    birthdayController.addListener(() => validateBirthday(birthdayController.text));
  }

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  void validatefName(String value) {
    isfNameValid = value.isNotEmpty;
    notifyListeners();
  }
  void validatelName(String value) {
    islNameValid = value.isNotEmpty;
    notifyListeners();
  }

  void validateEmail(String value) {
    isEmailValid = value.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
    notifyListeners();
  }

  void validatePassword(String value) {
    final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,8}$');
    isPasswordValid = passwordRegExp.hasMatch(value);
    notifyListeners();
  }

  void validateConfirmPassword(String value) {
    isConfirmPasswordValid = value == passwordController.text;
    notifyListeners();
  }

  void validateBirthday(String value) {
    isBirthdayValid = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value);
    notifyListeners();
  }

  void setGender(String newGender) {
    gender = newGender;
    notifyListeners();
  }

  Future<bool> checkEmailExists(String email) async {
  final url = Uri.parse('${Config.baseUrl}/api/client/check-email'); // Replace with your actual API URL
  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.post(url, headers: headers, body: email);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Assuming API returns true/false as JSON response
    } else {
      developer.log('Failed to check email existence: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    developer.log('Error checking email existence: $e');
    throw Exception('Could not connect to the server');
  }
}

 void _onEmailChanged(String email) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (email.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
        try {
          isEmailAlreadyExists = await checkEmailExists(email);
        } catch (e) {
          developer.log('Error during email validation: $e');
          isEmailAlreadyExists = false;
        }
      } else {
        isEmailAlreadyExists = false;
      }
      notifyListeners();
    });
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var digest = sha256.convert(bytes); // Hash the password using SHA-256
    return digest.toString(); // Convert the digest to a string
  }

  Future<void> handleSignUp(BuildContext context) async {
    if (!formKey.currentState!.validate() || isEmailAlreadyExists) {
      return;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    // final dbCheckSuccess = await checkDatabase(context);
    // if (!dbCheckSuccess) {
    //   errorMessage = 'Database check failed. Please try again later.';
    //   isLoading = false;
    //   notifyListeners();
    //   showErrorDialog(context, errorMessage);
    //   return;
    // }

    showLoadingDialog(context);


//pass the email, fname, lname, gender, bdate,password to client table **********************

    final url = Uri.parse('${Config.baseUrl}/api/client/saveClient');
    final headers = {'Content-Type': 'application/json'};
    final hashedPassword = hashPassword(passwordController.text); // Hash the password
    final body = jsonEncode({
      'email': emailController.text,
      'fname': fNameController.text,
      'lname': lNameController.text,
      'gender': gender,
      'birthDate': birthdayController.text,
      
      'password': hashedPassword, // Use the hashed password
    });

    developer.log('Sending request to $url');
    developer.log('Request body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        isLoading = false;
        notifyListeners();
        if (context.mounted) {
          Navigator.of(context).pop();
          showLoginSuccessDialog(context, 'Registered successfully”',Icons.check_circle);
          Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(
          formKey.currentContext!,
          '/login'
          
  
        );
      });
          
        }
      } else {
        errorMessage = 'Failed to register user';
        isLoading = false;
        notifyListeners();
        if (context.mounted) {
          Navigator.of(context).pop();
          showLoginSuccessDialog(context, errorMessage,Icons.close);
        }
      }
    } catch (e) {
      errorMessage = 'An error occurred during registration. Please try again.';
      isLoading = false;
      notifyListeners();
      if (context.mounted) {
        Navigator.of(context).pop();
        showLoginSuccessDialog(context, errorMessage,Icons.close);
      }
      developer.log('Error: $e');
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.infinity,
            height: 100,
            color: Colors.white,
            child: const Center(
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

  void showLoginSuccessDialog(BuildContext context, String message, IconData icon) {
  showDialog(
    context: context,
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
                    icon, // Use the icon parameter here
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
}
