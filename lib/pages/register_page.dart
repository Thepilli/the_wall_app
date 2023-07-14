import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_social_app/components/button.dart';

import '../components/sized_box.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailTextConroller = TextEditingController();
  final passwordTextConroller = TextEditingController();
  final confirmPasswordTextConroller = TextEditingController();

//sign in function
  void signUp() async {
//show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

//check if passwords match
    if (passwordTextConroller.text != confirmPasswordTextConroller.text) {
      //pop loading circle
      Navigator.pop(context);

      //display error message
      displayErrorMessage('Passwords do not match');
    }

    //try to create a new user
    try {
      // create a new user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextConroller.text,
        password: passwordTextConroller.text,
      );

      //after creating a new user, create a new document in the cloud firestore collection called Users
      FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.email).set({
        'username': emailTextConroller.text.split('@')[0], //initial username
        'bio': 'empty bio...', //initial bio
        //add more fields here when needed
      });

      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //display error message
      displayErrorMessage(e.code);
    }
  }

  //display error message dialog
  void displayErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  const MySizedBox50(),
                  const Icon(
                    Icons.account_circle,
                    size: 100.0,
                    color: Colors.black,
                  ),

                  const MySizedBox50(),

                  // welcome back message
                  Text(
                    'Let\'s Get Started and set up your account',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),

                  const MySizedBox25(),

                  // email TF
                  MyTextField(
                    controller: emailTextConroller,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const MySizedBox10(),

                  // password TF
                  MyTextField(
                    controller: passwordTextConroller,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const MySizedBox10(),
                  // confirm password TF
                  MyTextField(
                    controller: confirmPasswordTextConroller,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const MySizedBox25(),

                  // sign in button
                  MyButton(
                    text: 'Sign up',
                    onTap: signUp,
                  ),
                  const MySizedBox25(),
                  // go to register page

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text('Log in now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, '/register');
                      //   },
                      //   child: const Text('Register'),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
