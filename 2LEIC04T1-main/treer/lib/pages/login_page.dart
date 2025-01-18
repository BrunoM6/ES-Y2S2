import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail() {
    final RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9_%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
    );
    return regex.hasMatch(_emailController.text.trim());
  }

  Future<void> _resetPassword(String email) async {
    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Email Required',
            content: 'Please enter your email.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (!_isValidEmail()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Invalid Email',
            content: 'The email you entered is not valid.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Email Sent',
            content: 'A password reset link has been sent to the provided email.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Error',
            content: 'Something went wrong. Please try again.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: email.isEmpty
                ? 'Email Required'
                : 'Password Required',
            content: email.isEmpty
                ? 'Please enter your email.'
                : 'Please enter your password.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (!_isValidEmail()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Invalid Email',
            content: 'The email you entered is not valid.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Invalid Credentials',
            content: 'Invalid email or password. Please try again.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'TreeR',
                          style: GoogleFonts.inknutAntiqua(
                              color: AppColors.darkGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 40
                          )
                        ),
                        Text(
                          'Login',
                          style: GoogleFonts.inknutAntiqua(
                              color: AppColors.darkGreen,
                              fontSize: 22
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height : 32),
                    Column (
                      children: <Widget>[
                        CustomTextFieldAlt(
                            hintText: "Introduce your email",
                            controller: _emailController,
                            obscureText: false
                        ),
                        const SizedBox(height : 24),
                        CustomTextFieldAlt(
                            hintText: "Introduce your password",
                            controller: _passwordController,
                            obscureText: true
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _signIn,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.lightGreen
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text('Sign In',
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height : 16),
                        GestureDetector(
                          onTap: () => _resetPassword(_emailController.text.trim()),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.lato(
                                color: AppColors.darkGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 22
                            )
                          )
                        ),
                      ],
                    ),
                  ]
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Don\'t have an account?',
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 20
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => const RegisterPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(0.0, 1.0);
                            var end = Offset.zero;
                            var curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          }
                        )
                      );
                      _emailController.clear();
                      _passwordController.clear();
                    },
                    child: Text(
                      'Register',
                      style: GoogleFonts.lato(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      )
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
