import 'package:treer/treer.dart';
import 'package:treer/styles.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "",
        authDomain: "treer-e3d77.firebaseapp.com",
        projectId: "treer-e3d77",
        storageBucket: "treer-e3d77.appspot.com",
        messagingSenderId: "22300292541",
        appId: "1:22300292541:android:88e0d040255f43f0cb0ed4",
      ),
    );
  } catch (e) {
    throw Exception('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Treer',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthRouter(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/add_post': (context) => const AddPostPage(),
        '/add_product': (context) => const AddProductPage(),
      }
    );
  }
}

class AuthRouter extends StatelessWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/home');
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });
            }
          }
          return const Scaffold(body: Center(
            child: CircularProgressIndicator(
              color: AppColors.lightGreen,
              strokeWidth: 5.0,
            )
          ));
        }
      ),
    );
  }
}
