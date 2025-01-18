import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: 21.0
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        labelText: labelText,
        labelStyle: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 25.0
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.lightGreen, width: 3),
        ),
      ),
    );
  }
}
