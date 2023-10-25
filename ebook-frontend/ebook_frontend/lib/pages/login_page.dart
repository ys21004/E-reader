import 'package:ebook_frontend/components/my_button.dart';
import 'package:ebook_frontend/components/my_textfield.dart';
import 'package:ebook_frontend/components/square_tile.dart';
import 'package:ebook_frontend/scripts/login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

                  //Forgot Password
                  const Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Forgot Password?',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  //Sign In Button
                  MyButton(text: 'Sign in',onTap: signUserIn),

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

                  //Register
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Not a member?'),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
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


