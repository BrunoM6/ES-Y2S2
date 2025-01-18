import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _material = 'Plastic';
  final List<String> _materialList = ['Plastic', 'Paper', 'Glass'];
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveProductInfo() async {
    String name = _nameController.text.trim();

    if (name.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Empty Field',
            content: 'Please fill in the product name.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (_material == 'Material') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Empty Selector',
            content: 'Please select a material.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z\sáéíóúÁÉÍÓÚâêîôûÂÊÎÔÛãõÃÕçÇ]+$').hasMatch(_nameController.text.trim())) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Invalid Product Name',
            content: 'Product Name can only contain letters.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    String lowerCaseName = name.toLowerCase().replaceAll(RegExp(r'\s'), '');
    final QuerySnapshot query = await _firestore
        .collection('product')
        .where('lowercasename', isEqualTo: lowerCaseName)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Error',
            content: 'This product already exists.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    try{
      String postID = generatePostId();

      await _firestore.collection('product').doc(postID).set({
        'lowercasename': lowerCaseName,
        'name': name,
        'material': _material,
      });

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Success',
            content: 'Product created successfully.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );

      Navigator.pop(context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const HomePage(),
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
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Error',
            content: 'An error occurred. Please try again.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 36),
          onPressed: () {
            Navigator.pop(context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const HomePage(),
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
          },
        ),
        backgroundColor: AppColors.lightGreen,
        toolbarHeight: kToolbarHeight + MediaQuery.of(context).padding.top * 0.5,
        title: Text('Add Product', style: GoogleFonts.lato(fontSize: 30, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16,24,16,16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  CustomTextFieldAlt(
                    hintText: 'Product Name',
                    controller: _nameController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomListSelector(
                          title: 'Material',
                          selected: _material,
                          stringList: _materialList,
                          onChanged: (String selected) {
                            setState(() {
                              _material = selected;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProductInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGreen
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('Create Post',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 22.0,
                        )
                      ),
                    )
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
