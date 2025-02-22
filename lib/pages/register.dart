import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/register_screen_state.dart'; // Ensure this imports your RegisterScreenState class

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterScreenState(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, '/welcome');
            },
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(left: 40),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: 40.0,
                                color: Colors.white,
                                fontFamily: "Lato",
                                fontWeight: FontWeight.w900,
                              ),
                          children: const [
                            TextSpan(text: 'Create Your\n'),
                            TextSpan(
                              text: 'Account',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 40,
                                fontFamily: "Lato",
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: const _RegisterForm(),
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

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RegisterScreenState>(context);

    return Form(
      key: state.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
        child: Column(
          children: [
            TextFormField(
              controller: state.fNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                hintText: 'Charitha',
                suffixIcon: Icon(
                  state.isfNameValid ? Icons.check : Icons.close,
                  color: state.isfNameValid ? Colors.green : Colors.red,
                ),
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
              validator: (value) {
                state.validatefName(value!);
                if (value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),

            const SizedBox(height: 10),
            TextFormField(
              controller: state.lNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                hintText: 'Bimsara',
                suffixIcon: Icon(
                  state.islNameValid ? Icons.check : Icons.close,
                  color: state.islNameValid ? Colors.green : Colors.red,
                ),
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
              validator: (value) {
                state.validatelName(value!);
                if (value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: state.emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'charitha@gmail.com',
                suffixIcon: Icon(
                  state.isEmailValid ? Icons.check : Icons.close,
                  color: state.isEmailValid ? Colors.green : Colors.red,
                ),
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
              validator: (value) {
                state.validateEmail(value!);
                if (value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                if (state.isEmailAlreadyExists) {
                  return 'Email already exists';
                }
                return null;
              },
            ),
               const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              menuMaxHeight: 100,
              value: state.gender,
              items: <String>['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                state.setGender(newValue!);
              },
              decoration: InputDecoration(
                
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your gender';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: state.birthdayController,
              decoration: InputDecoration(
                labelText: 'Birthday',
                hintText: 'YYYY-MM-DD',
                suffixIcon: Icon(
                  state.isBirthdayValid ? Icons.check : Icons.close,
                  color: state.isBirthdayValid ? Colors.green : Colors.red,
                ),
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
              validator: (value) {
                state.validateBirthday(value!);
                if (value.isEmpty) {
                  return 'Please enter your birthday';
                }
                if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                  return 'Please enter a valid date in YYYY-MM-DD format';
                }
                return null;
              },
            ),
        
            const SizedBox(height: 10),
            TextFormField(
              controller: state.passwordController,
              obscureText: state.obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: state.toggleObscurePassword,
                ),
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
              validator: (value) {
                state.validatePassword(value!);
                if (value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: state.confirmPasswordController,
              obscureText: state.obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: state.toggleObscureConfirmPassword,
                ),
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
              validator: (value) {
                state.validateConfirmPassword(value!);
                if (value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != state.passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
             const SizedBox(height: 40),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => state.handleSignUp(context),
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
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Already have an account?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(
                        milliseconds: 500)); // Add delay before navigating
                    if (!context.mounted) {
                      return; // Ensure the widget is still mounted
                    }
                    Navigator.pushReplacementNamed(
                        context, '/login'); // Navigate to the login screen
                  },
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
