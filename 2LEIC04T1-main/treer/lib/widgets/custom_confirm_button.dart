import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomConfirmButton extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback action;

  const CustomConfirmButton({
    super.key,
    required this.title,
    required this.content,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: AppColors.lightGreen,
        size: 45,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 28,
            ),
          ),
        ],
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          fontSize: 22,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () { Navigator.of(context).pop(); },
              child: Text(
                'Cancel',
                style: GoogleFonts.lato(
                  color: AppColors.lightGreen,
                  fontSize: 22,
                ),
              ),
            ),
            TextButton(
              onPressed: action,
              child: Text(
                'Confirm',
                style: GoogleFonts.lato(
                  color: AppColors.lightGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
