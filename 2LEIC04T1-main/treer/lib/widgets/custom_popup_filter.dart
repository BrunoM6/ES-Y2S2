import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPopUpFilter extends StatefulWidget {
  final String title;
  final String currentFilter;
  final List<String> materials;

  const CustomPopUpFilter({
    super.key,
    required this.title,
    required this.materials,
    required this.currentFilter,
  });

  @override
  State<CustomPopUpFilter> createState() => _CustomPopUpFilterState();
}

class _CustomPopUpFilterState extends State<CustomPopUpFilter> {
  late String selectedMaterial;

  @override
  void initState() {
    super.initState();
    selectedMaterial = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          widget.title,
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            for (var material in widget.materials)
              ListTile(
                tileColor: selectedMaterial == material
                    ? AppColors.lightGreen.withOpacity(0.2)
                    : null,
                title: Text(
                  material,
                  style: GoogleFonts.lato(
                    color: selectedMaterial == material
                        ? AppColors.darkGreen
                        : Colors.black,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (selectedMaterial == material) {
                      selectedMaterial = "";
                    } else {
                      selectedMaterial = material;
                    }
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(selectedMaterial);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightGreen,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Save Filter',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
