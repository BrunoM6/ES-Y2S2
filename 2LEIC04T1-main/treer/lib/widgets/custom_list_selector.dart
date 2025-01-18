import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListSelector extends StatefulWidget {
  final String title;
  final String selected;
  final List<String> stringList;
  final ValueChanged<String> onChanged;

  const CustomListSelector({
    super.key,
    required this.title,
    required this.selected,
    required this.onChanged,
    required this.stringList,
  });

  @override
  State<CustomListSelector> createState() => _CustomListSelectorState();
}

class _CustomListSelectorState extends State<CustomListSelector> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await showDialog<String>(
          context: context,
          builder: (context) => CustomPopUpFilter(
            title: widget.title,
            materials: widget.stringList,
            currentFilter: selectedOption,
          ),
        );
        if (selected != null) {
          if (selected != "") {
            setState(() {
              selectedOption = selected;
            });
          } else {
            setState(() {
              selectedOption = widget.title;
            });
          }
          widget.onChanged(selected);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selectedOption == widget.title
            ? Colors.grey[100]
            : AppColors.lightGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Text(
          selectedOption,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            color: selectedOption == widget.title
              ? Colors.grey[800]
              : AppColors.darkGreen,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
