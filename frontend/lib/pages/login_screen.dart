import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/login_screen_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginScreenState(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/welcome');
            },
          ),
          backgroundColor: Colors.black,
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
                    const SizedBox(height: 100),
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
                            TextSpan(text: 'Welcome\n'),
                            TextSpan(
                              text: 'Back',
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: const _LoginForm(),
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

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LoginScreenState>(context);

    return Form(
      key: state.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: state.isEmailValid,
              builder: (context, isValid, child) {
                return TextFormField(
                  controller: state.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'charitha@gmail.com',
                    suffixIcon: Icon(
                      isValid ? Icons.check : Icons.close,
                      color: isValid ? Colors.green : Colors.red,
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 20),
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
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            if (state.errorMessage.isNotEmpty)
              Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            Transform.translate(
              offset: Offset(0, -20),
              child: TextButton(
                onPressed: () async {
                  await Future.delayed(const Duration(
                      milliseconds: 500)); // Add delay before navigating
                  if (!context.mounted) {
                    return; // Ensure the widget is still mounted
                  }
                  Navigator.pushReplacementNamed(context,
                      '/forgot_password'); // Navigate to the login screen
                },
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: state.handleLogin,
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
                          "SIGN IN",
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
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Don't have an account?",
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
                        context, '/register'); // Navigate to the login screen
                  },
                  child: const Text(
                    "SIGN UP",
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
            const SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }
}
