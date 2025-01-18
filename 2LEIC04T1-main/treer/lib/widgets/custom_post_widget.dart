import 'dart:typed_data';
import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostData {
  final String title;
  final String postID;
  final String productID;
  final String description;
  final String productName;
  final Uint8List imageBytes;

  PostData(
    this.title,
    this.postID,
    this.productID,
    this.imageBytes,
    this.description,
    this.productName,
  );
}

class CustomPostWidget extends StatelessWidget {
  final PostData postData;

  const CustomPostWidget({
    super.key,
    required this.postData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => PostPage(postID: postData.postID),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, -1.0);
              var end = Offset.zero;
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
      child: SizedBox(
        height: 250,
        child: Card(
          elevation: 10,
          color: AppColors.buttonGreen,
          margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 170,
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
                  child: AspectRatio(
                    aspectRatio: 2/3,
                    child: Image.memory(
                      postData.imageBytes,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 165,
                    width: (MediaQuery.of(context).size.width * 2) / 5,
                    child: Column(
                      children: [
                        Text(
                          postData.title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => ProductPage(productID: postData.productID),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  var begin = const Offset(0.0, -1.0);
                                  var end = Offset.zero;
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                              child: Text(
                                postData.productName,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: AppColors.darkGreen,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          postData.description,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String generatePostId() {
  String userID = FirebaseAuth.instance.currentUser!.uid;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String postId = '$userID-$timestamp';
  return postId;
}

Future<List<PostData>> getPostData(String typeFilter, String materialFilter, String productIDFilter) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late String title;
  late String postID;
  late String productID;
  late String description;
  late String productName;
  late Uint8List? imageBytes;
  late String productMaterial;

  List<PostData> postDataList = [];
  final QuerySnapshot<Map<String, dynamic>> postsQuery;

  if (typeFilter != '') {
    postsQuery = await firestore.collection('post').where('type', isEqualTo: typeFilter).get();
  } else {
    postsQuery = await firestore.collection('post').get();
  }

  for (var doc in postsQuery.docs) {
    postID = doc.id;
    title = doc['title'];
    productID = doc['product'];
    description = doc['description'];

    if (productIDFilter != '' && productIDFilter != productID) { continue; }

    final DocumentSnapshot<Map<String, dynamic>> productDocument = await firestore
        .collection('product')
        .doc(productID)
        .get();

    productName = productDocument['name'];
    productMaterial = productDocument['material'];
    
    if (materialFilter != '' && materialFilter != productMaterial) { continue; }
    
    imageBytes = (await storage.ref('posts/$postID.jpeg').getData())!;

    postDataList.add(PostData(
      title,
      postID,
      productID,
      imageBytes,
      description,
      productName,
    ));
  }

  return postDataList;
}
