import 'dart:typed_data';
import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late User _currentUser;
  late DocumentSnapshot _userDocument;
  late Uint8List? _profilePictureBytes;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
  }

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _currentUser.email!);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Email Sent',
            content: 'A password reset link has been sent to your email.',
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
            content: 'An error occurred while sending the email.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final Uint8List imageBytes = Uint8List.fromList(await image.readAsBytes());
    await _storage.ref('profile_pictures/${_currentUser.uid}.jpeg').putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg')
    );

    setState(() {
      _loadUserInformation();
    });
  }

  Future<void> _loadUserInformation() async {
    _currentUser = _auth.currentUser!;

    _userDocument = await _firestore.collection('users').doc(_currentUser.uid).get();
    if (!_userDocument.exists) {
      _userDocument = await _firestore.collection('users').doc('default').get();
    }

    _nameController.text = _userDocument['name'];
    _usernameController.text = _userDocument['username'];

    try {
      _profilePictureBytes = await _storage.ref('profile_pictures/${_currentUser.uid}.jpeg').getData();
    } catch (e) {
      _profilePictureBytes = await _storage.ref('profile_pictures/default.jpeg').getData();
    }
  }

  Future<void> _saveUserInformation() async {
    String name = _nameController.text.trim();
    String username = _usernameController.text.toLowerCase().trim();

    if (name.isEmpty || username.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Empty Field',
            content: name.isEmpty ? 'Name cannot be empty.' : 'Username cannot be empty.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z\sáéíóúÁÉÍÓÚâêîôûÂÊÎÔÛãõÃÕçÇ]+$').hasMatch(name)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Invalid Name',
            content: 'Name can only contain letters.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Invalid Username',
            content: 'Username can only contain letters and numbers.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    final QuerySnapshot query = await _firestore.collection('users').where('username', isEqualTo: username).limit(1).get();
    if (query.docs.isNotEmpty && query.docs[0].id != _currentUser.uid) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Invalid Username',
            content: 'Username is already in use.',
            action: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    name = name.replaceAll(RegExp(r'\s\s+'), ' ');
    name = name.toLowerCase().split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');

    await _firestore.collection('users').doc(_currentUser.uid).set({
      'name': name,
      'username': username,
    });
    
    setState(() {
      _loadUserInformation();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUserInformation(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(
              child: CircularProgressIndicator(
                color: AppColors.lightGreen,
                strokeWidth: 5.0,
              )
          ));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: kToolbarHeight + MediaQuery.of(context).padding.top,
              title: Text('Edit Profile', style: GoogleFonts.lato(fontSize: 27)),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 32),
                  onPressed: () {
                    Navigator.pop(context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => const HomePage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = Offset.zero;
                          var end = const Offset(0.0, -1.0);
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
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16,16,16,32),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: Image.memory(_profilePictureBytes!).image,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Upload Image',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 22.0,
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget> [
                            CustomTextField(
                              controller: _nameController,
                              labelText: 'Name',
                            ),
                            const SizedBox(height: 28.0),
                            CustomTextField(
                              controller: _usernameController,
                              labelText: 'Username',
                            ),
                            const SizedBox(height: 28.0),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomConfirmButton(
                                      title: 'Change Password',
                                      content: 'Are you sure you want to change your password?',
                                      action: () {
                                        Navigator.of(context).pop();
                                        _resetPassword();
                                      },
                                    );
                                  },
                                );
                              },
                              child: Text('Change Password',
                                style: GoogleFonts.lato(
                                  color: AppColors.lightGreen,
                                  decoration: TextDecoration.underline,
                                  fontSize: 22.0,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveUserInformation,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.lightGreen
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text('Save',
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
