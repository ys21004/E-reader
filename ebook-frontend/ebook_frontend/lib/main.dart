import 'package:ebook_frontend/firebase_options.dart';
import 'package:ebook_frontend/pages/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ebook_frontend/services/firebase_auth_methods.dart';
import 'package:ebook_frontend/pages/register_page.dart';
import 'package:ebook_frontend/pages/auth_utils.dart';
import 'package:ebook_frontend/custom_button.dart';
import 'package:ebook_frontend/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth _auth = FirebaseAuth.instance;

  runApp(MyApp(auth: _auth));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth auth;

  const MyApp({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => RegisterPage(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login_page');
              },
            ),
        '/login_page': (context) => LoginPage(
              onTap: () {
                
              },
            ),
        '/verification_page': (context) => VerificationScreenState(
              email: "", 
              auth: auth,
            ),
        
      },
      title: "Your App Title",
    );
  }
}
