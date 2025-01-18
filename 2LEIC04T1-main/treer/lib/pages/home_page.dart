import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // CHANGE THIS TO SET THE DEFAULT LANDING PAGE
  String _currentFilter = "None";

  List<Widget> _widgetList = <Widget>[
    const ReducePage(filter: ""),
    const ReusePage(filter: ""),
    const RecyclePage(filter: ""),
  ];

  void updateWidgetFilter(String filterValue) {
    setState(() {
      _widgetList = [
        ReducePage(filter: filterValue),
        ReusePage(filter: filterValue),
        RecyclePage(filter: filterValue),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.lightGreen,
        toolbarHeight: kToolbarHeight + MediaQuery.of(context).padding.top * 0.65,
        title: Text('Home', style: GoogleFonts.lato(fontSize: 28, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 36),
            onPressed: () {
              Navigator.push(context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const EditProfilePage(),
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
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 36),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18,16,18,4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  tooltip: 'Add Post',
                  backgroundColor: AppColors.buttonGreen,
                  onPressed: () {
                    Navigator.push(context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => const AddPostPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(0.0, 1.0);
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
                  child: const Icon(Icons.add_rounded, color: Colors.white),
                ),
                FloatingActionButton(
                  tooltip: 'Filter Posts',
                  backgroundColor: AppColors.buttonGreen,
                  onPressed:() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomPopUpFilter(
                          title: 'Material',
                          currentFilter: _currentFilter,
                          materials: const ['Plastic', 'Paper', 'Glass'],
                        );
                      },
                    ).then((newFilter) {
                      _currentFilter = newFilter;
                      updateWidgetFilter(newFilter);
                    });
                  },
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ),
                FloatingActionButton(
                  tooltip: 'Add Product',
                  backgroundColor: AppColors.buttonGreen,
                  onPressed: () {
                    Navigator.push(context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => const AddProductPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(0.0, 1.0);
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
                  child: const Icon(Icons.add_to_photos_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.lightGreen,
            height: 30,
            thickness: 2,
            indent: 18,
            endIndent: 18,
          ),
          Expanded(
            child: Center(
              child: IndexedStack(
                index: _selectedIndex,
                children: _widgetList,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          _currentFilter = '';
          _selectedIndex = index;
          updateWidgetFilter('');
        },
      ),
    );
  }
}

class ReducePage extends StatelessWidget {
  final String filter;

  const ReducePage({
    super.key,
    required this.filter
  });

  Future<List<PostData>> _fetchPosts() async {
    return getPostData('Reduce', filter, '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PostData> posts = snapshot.data!;
          if (posts.isEmpty) {
            return Center(
              child: Text(
                'No posts found',
                style: GoogleFonts.lato(fontSize: 24, color: AppColors.lightGreen),
              ),
            );
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return CustomPostWidget(postData: posts[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const CircularProgressIndicator(
            color: AppColors.lightGreen,
            strokeWidth: 5.0,
          );
        }
      },
    );
  }
}

class ReusePage extends StatelessWidget {
  final String filter;

  const ReusePage({
    super.key,
    required this.filter
  });

  Future<List<PostData>> _fetchPosts() async {
    return getPostData('Reuse', filter, '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostData>>(
      future: _fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PostData> posts = snapshot.data!;
          if (posts.isEmpty) {
            return Center(
              child: Text(
                'No posts found',
                style: GoogleFonts.lato(fontSize: 24, color: AppColors.lightGreen),
              ),
            );
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return CustomPostWidget(postData: posts[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const CircularProgressIndicator(
            color: AppColors.lightGreen,
            strokeWidth: 5.0,
          );
        }
      },
    );
  }
}

class RecyclePage extends StatelessWidget {
  final String filter;

  const RecyclePage({
    super.key,
    required this.filter
  });

  Future<List<PostData>> _fetchPosts() async {
    return getPostData("Recycle", filter, '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostData>>(
      future: _fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PostData> posts = snapshot.data!;
          if (posts.isEmpty) {
            return Center(
              child: Text(
                'No posts found',
                style: GoogleFonts.lato(fontSize: 24, color: AppColors.lightGreen),
              ),
            );
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return CustomPostWidget(postData: posts[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const CircularProgressIndicator(
            color: AppColors.lightGreen,
            strokeWidth: 5.0,
          );
        }
      },
    );
  }
}
