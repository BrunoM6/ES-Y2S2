import 'dart:typed_data';
import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostPage extends StatefulWidget {
  final String postID;

  const PostPage({
    super.key,
    required this.postID,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late String _date;
  late String _type;
  late String _title;
  late String _productID;
  late String _description;

  late String _productName;
  late String _productMaterial;

  late Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  Future<void> _loadPostData() async {
    final DocumentSnapshot<Map<String, dynamic>> postInfo = await _firestore
        .collection('post')
        .doc(widget.postID)
        .get();

    _date = postInfo['date'];
    _type = postInfo['type'];
    _title = postInfo['title'];
    _productID = postInfo['product'];
    _description = postInfo['description'];

    final DocumentSnapshot<Map<String, dynamic>> productInfo = await _firestore
        .collection('product')
        .doc(_productID)
        .get();

    _productName = productInfo['name'];
    _productMaterial = productInfo['material'];

    _imageBytes = await _storage
        .ref('posts/${widget.postID}.jpeg')
        .getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPostData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(
            child: CircularProgressIndicator(
              color: AppColors.lightGreen,
              strokeWidth: 5.0,
            ),
          ));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.lightGreen,
              toolbarHeight: kToolbarHeight + MediaQuery.of(context).padding.top * 0.75,
              title: Text(
                _productName,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(fontSize: 27, color: Colors.white),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
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
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 7,
                                spreadRadius: 5,
                                offset: const Offset(0, 3),
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(
                              _imageBytes!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            _title,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: 28,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Text(
                                      _productMaterial,
                                      style: GoogleFonts.lato(
                                        fontSize: 22,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Text(
                                      _type,
                                      style: GoogleFonts.lato(
                                        fontSize: 22,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                _date,
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _description,
                            style: GoogleFonts.lato(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    );
  }
}
