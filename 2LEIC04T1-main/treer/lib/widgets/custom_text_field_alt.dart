import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFieldAlt extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextFieldAlt({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
  });

  @override
  State<CustomTextFieldAlt> createState() => _CustomTextFieldAltState();
}

class _CustomTextFieldAltState extends State<CustomTextFieldAlt> {
  late bool showPassword;

  @override
  void initState() {
    super.initState();
    showPassword = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: showPassword,
      style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: 20.0
      ),
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        fillColor: Colors.grey[100],
        suffixIcon: widget.obscureText
          ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                showPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded
              )
            )
          : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: Colors.black, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppColors.lightGreen, width: 3),
        ),
      ),
    );
  }
}
