import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: currentIndex,
      iconSize: 30.0,
      selectedFontSize: 15.0,
      selectedItemColor: Colors.white,
      selectedLabelStyle: GoogleFonts.lato(color: Colors.white),
      unselectedFontSize: 15.0,
      unselectedItemColor: AppColors.darkGreen,
      unselectedLabelStyle: GoogleFonts.lato(color: AppColors.darkGreen),
      backgroundColor: AppColors.lightGreen,
      items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(
          label: 'Reduce',
          icon: Icon(Icons.receipt),
          activeIcon: Icon(Icons.receipt_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Reuse',
          icon: Icon(Icons.autorenew),
          activeIcon: Icon(Icons.autorenew_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Recycle',
          icon: Icon(Icons.delete_rounded),
          activeIcon: Icon(Icons.delete_outline_rounded)
        ),
      ],
    );
  }
}
