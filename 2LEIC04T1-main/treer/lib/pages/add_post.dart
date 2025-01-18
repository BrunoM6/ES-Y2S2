import 'dart:typed_data';
import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _type = 'Type';
  Uint8List imageBytes = Uint8List(0);
  final List<String> _typeList = ['Reduce', 'Reuse', 'Recycle'];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isValidName() {
    return RegExp(r'^[a-zA-Z\sáéíóúÁÉÍÓÚâêîôûÂÊÎÔÛãõÃÕçÇ]+$').hasMatch(_nameController.text.trim());
  }

  bool _isValidTitle() {
    return RegExp(r'^[a-zA-Z\sáéíóúÁÉÍÓÚâêîôûÂÊÎÔÛãõÃÕçÇ0-9]+$').hasMatch(_titleController.text.trim());
  }

  void _resetPage() {
    setState(() {
      _type = 'Type';
      imageBytes = Uint8List(0);

      _nameController.clear();
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    imageBytes = Uint8List.fromList(await image.readAsBytes());

    setState(() {});
  }

  Future<void> _savePostInfo() async {
    String name = _nameController.text.trim();
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    if (name.isEmpty || title.isEmpty || description.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Empty Fields',
            content: 'Please fill in all fields.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (_type == 'Type') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Empty Selector',
            content: 'Please select a type.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (imageBytes.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'No Image',
            content: 'Please add an image.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (!_isValidName() || !_isValidTitle()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: !_isValidName()
              ? 'Invalid Product Name'
              : 'Invalid Title',
            content: !_isValidName()
              ? 'Product Name can only contain letters.'
              : 'Title can only contain letters and numbers.',
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

    if (query.docs.isEmpty) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Error',
            content: 'This product does not exist.',
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

      await _firestore.collection('post').doc(postID).set({
        'date': '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
        'type': _type,
        'title': title,
        'product': query.docs.first.id,
        'description': description,
      });

      await _storage.ref('posts/$postID.jpeg').putData(
          imageBytes,
          SettableMetadata(contentType: 'image/jpeg')
      );

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Success',
            content: 'Post created successfully.',
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

  Widget _getCreatePostButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
              onPressed: _savePostInfo,
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
    );
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
        title: Text('Add Post', style: GoogleFonts.lato(fontSize: 30, color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 36),
              onPressed: _resetPage,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  CustomTextFieldAlt(
                    hintText: 'Product Name',
                    controller: _nameController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomListSelector(
                          title: 'Type',
                          selected: _type,
                          stringList: _typeList,
                          onChanged: (String selected) {
                            setState(() {
                              _type = selected;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextFieldAlt(
                    hintText: 'Title',
                    controller: _titleController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    minLines: 8,
                    maxLines: 15,
                    controller: _descriptionController,
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 20.0
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Description',
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.black, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: AppColors.lightGreen, width: 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (imageBytes.isNotEmpty) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGreen
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(imageBytes.isEmpty
                            ? Icons.add_a_photo_rounded
                            : Icons.edit_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Text(imageBytes.isEmpty
                            ? 'Add Image'
                            : 'Change Image',
                            style: GoogleFonts.lato(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (imageBytes.isNotEmpty) ...[
                    const SizedBox(height: 16.0),
                    _getCreatePostButton(),
                    const SizedBox(height: 16.0),
                  ],
                ],
              ),
            ),
            if (imageBytes.isEmpty) ...[
              const SizedBox(height: 16.0),
              _getCreatePostButton(),
              const SizedBox(height: 16.0),
            ],
          ],
        ),
      ),
    );
  }
}
