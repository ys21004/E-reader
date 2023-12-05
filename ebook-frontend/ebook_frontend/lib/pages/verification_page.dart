import 'package:ebook_frontend/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebook_frontend/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ebook_frontend/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ebook_frontend/utils/showSnackBar.dart';

class VerificationScreenState extends StatefulWidget {
  final String email;
  final FirebaseAuth auth;

  VerificationScreenState({required this.email, required this.auth});

  @override
  State<VerificationScreenState> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreenState> {
  @override
  void initState() {
    super.initState();
    // Call verifyEmail function when the screen is initialized
    verifyEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Image moved above the text
                Image.asset(
                  'lib/images/image.jpeg', // Replace with your actual image path
                  width: 400, // Adjust width as needed
                  height: 400, // Adjust height as needed
                ),
                const SizedBox(height: 20),
                Text(
                  "A verification link has been sent to your email address. Please check your email and click on the link to verify your account.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login_page');
                    },
                    text: "Go to Login Page",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to initiate email verification
  void verifyEmail() async {
    try {
      var acs = ActionCodeSettings(
        url: 'https://eread.page.link/63fF=${widget.email}',
        handleCodeInApp: true,
        iOSBundleId: 'com.example.ios',
        androidPackageName: 'com.example.android',
        androidInstallApp: true,
        androidMinimumVersion: '12',
      );

      await widget.auth.sendSignInLinkToEmail(
        email: widget.email,
        actionCodeSettings: acs,
      );

      // Show a success message to the user
      showSuccessMessage('Email verification link sent successfully!');
    } catch (error) {
      // Show an error message to the user
      showErrorMessage('Error sending email verification: $error');
    }
  }

  // Function to display success message
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Function to display error message
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
