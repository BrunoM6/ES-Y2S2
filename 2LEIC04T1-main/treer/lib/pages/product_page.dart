import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPage extends StatefulWidget {
  final String productID;

  const ProductPage({
    super.key,
    required this.productID,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _productName;
  late List<PostData> postDataList;

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    final DocumentSnapshot<Map<String, dynamic>> productInfo = await _firestore
        .collection('product')
        .doc(widget.productID)
        .get();

    _productName = productInfo['name'];
    postDataList = await getPostData('', '', widget.productID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadProductData(),
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
            body: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      itemCount: postDataList.length,
                      itemBuilder: (context, index) {
                        return CustomPostWidget(postData: postDataList[index]);
                      },
                    )
                  )
                ),
                const SizedBox(height: 10),
              ],
            )
          );
        }
      }
    );
  }
}
