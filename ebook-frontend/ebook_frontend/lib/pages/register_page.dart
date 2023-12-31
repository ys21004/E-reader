import 'package:ebook_frontend/components/my_button.dart';
import 'package:ebook_frontend/components/my_textfield.dart';
import 'package:ebook_frontend/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

void signUserUpApi(email, password) async {
  try {
    var response = await http.post(
        Uri.parse('${dotenv.env['DB_URL']}/api/auth/local/register'),
          headers: {
    'Content-Type': 'application/json', // Set the content type to JSON
    'Accept': 'application/json', // Specify that you expect JSON in the response
  },
        body: jsonEncode({"username": email, "email": email, "password": email}));
    print('The response is${response.body}');
    if (response.body.contains('error')){
      showErrorMessage('This email is already registered, please sign in or choose a different email');

    }
  } catch (e) {
    print('Failed to register: $e');
  }
  ;
}

 void signUserUp() {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validate email, password, and confirm password
    if (email.isEmpty) {
      showErrorMessage('Email cannot be empty.');
    } else if (!isValidEmail(email)) {
      showErrorMessage('Invalid email address.');
    } else if (password.isEmpty) {
      showErrorMessage('Password cannot be empty.');
    } else if (!isStrongPassword(password)) {
      showErrorMessage('Password must be at least 8 characters long and contain one capital letter and one number.');
    } else if (confirmPassword.isEmpty) {
      showErrorMessage('Confirm password cannot be empty.');
    } else if (confirmPassword != password) {
      showErrorMessage('Passwords do not match.');
    } else {
      signUserUpApi(email, password);
    }
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),

                  //Logo
                  Icon(
                    Icons.library_books,
                    size: 100,
                  ),

                  SizedBox(height: 50),

                  //Password Text Field
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  SizedBox(height: 20),

                  //Password Text Field
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  SizedBox(height: 20),


                  //Confirm Password Text Field
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),


                  SizedBox(height: 20),

                  //Sign In Button
                  MyButton(text: 'Sign Up',onTap: signUserUp),

                  SizedBox(height: 30),

                  //Continue With?
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                            thickness: 0.5,
                            color: Color.fromARGB(255, 150, 150, 150)),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or Continue with',
                            style: TextStyle(
                                color: Color.fromARGB(255, 136, 136, 136)),
                          )),
                      Expanded(
                          child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ))
                    ],
                  ),
                  SizedBox(height: 30),

                  //Google Button
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SquareTile(imagePath: 'lib/images/google-logo.png')
                  ]),

                  SizedBox(height: 45),

                  //Login
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Already have an account?'),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Now",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ])
                ],
              ),
            ),
          ),
        ));
  }
}


