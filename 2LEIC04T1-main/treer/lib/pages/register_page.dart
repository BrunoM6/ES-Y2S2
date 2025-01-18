import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isValidEmail() {
    final RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9_%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
    );
    return regex.hasMatch(_emailController.text.trim());
  }

  bool _isValidPassword() {
    if(_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
      return true;
    }
    return false;
  }

  bool _isPasswordSecure() {
    if (_passwordController.text.trim().length < 8) {
      return false;
    }

    if (!RegExp(r'[a-zA-Z0-9!#$%&*,.?]').hasMatch(_passwordController.text.trim())) {
      return false;
    }

    return true;
  }

  void _closePage() {
    Navigator.pop(context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset.zero;
          var end = const Offset(0.0, 1.0);
          var curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
      )
    );
  }

  Future<void> _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

    if (!_isValidPassword()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Invalid Password',
            content: 'The passwords you entered do not match.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (!_isPasswordSecure()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Insecure Password',
            content: 'Your password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number, and one special character.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Success',
            content: 'Your account has been created. Please login.',
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
      return;
    }

    _closePage();
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
                          'Register',
                          style: GoogleFonts.inknutAntiqua(
                            color: AppColors.darkGreen,
                            fontSize: 22
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height : 28),
                    Column(
                      children: <Widget>[
                        CustomTextFieldAlt(
                            hintText: "Introduce your email",
                            controller: _emailController,
                            obscureText: false
                        ),
                        const SizedBox(height : 20),
                        CustomTextFieldAlt(
                            hintText: "Introduce your password",
                            controller: _passwordController,
                            obscureText: true
                        ),
                        const SizedBox(height : 20),
                        CustomTextFieldAlt(
                            hintText: "Confirm password",
                            controller: _confirmPasswordController,
                            obscureText: true
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _signUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.lightGreen
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      'Sign Up',
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
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 20
                    )
                  ),
                  GestureDetector(
                    onTap: _closePage,
                    child: Text(
                      'Login',
                      style: GoogleFonts.lato(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      )
                    )
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
