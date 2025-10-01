import 'package:bankapp/screens/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../models/user.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool hidden = true;
  bool confirmHidden = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }


    try {

      final cred = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;


      final appUser = User(
        name: name,
        username: username,
        email: email,
        balance: 0.0,
        transactions: [],
      );


      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(appUser.toJson());

      // 4. Navigate or show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully ✅")),
      );

      Navigator.pop(context); // back to login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  } // register authentication


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF350035),Colors.black],begin: Alignment.topRight,end: Alignment.bottomCenter)
            ),
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:50),
                      ), // top spacing
                      Center(
                          child: Image.asset('assets/images/logo.png',height: 100,width: 100,)
                      ), //logo
                      Padding(
                        padding: const EdgeInsets.only(top:50),
                      ), // spacing between logo and text
                      Center(
                        child: Text('Create Account',
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Ubuntu',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white

                          ),
                        ),
                      ), // create account text
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Name*',style: TextStyle(color: Colors.white),),
                            ),
                            TextFormField(
                              controller: nameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'John Doe',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                              ),
                            ),
                          ],
                        ),
                      ), //name field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Username*',style: TextStyle(color: Colors.white),),
                            ),
                            TextFormField(
                              controller: usernameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'myAccount123',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                              ),
                            ),
                          ],
                        ),
                      ), // username field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Email Address*',style: TextStyle(color: Colors.white),),
                            ),
                            TextFormField(
                              controller: emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'example@gmail.com',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                              ),

                            ),
                          ],
                        ),
                      ), // email address field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Password*',style: TextStyle(color: Colors.white),),
                            ),
                            TextFormField(
                              controller: passwordController,
                              style: TextStyle(color: Colors.white),
                              obscureText: hidden,
                              decoration: InputDecoration(
                                hintText: '@12345#',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                                suffixIcon: IconButton(
                                  onPressed: (){hidden=!hidden;
                                  setState(() {
                                  });},
                                  icon: Icon(hidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  ),
                                ),
                              ),

                              validator: (value) {
                                if (value == null || value.isEmpty) return "Password required";
                                if (value.length < 6) return "At least 6 characters";
                                if (!RegExp(r'[A-Z]').hasMatch(value)) return "Must contain uppercase";
                                if (!RegExp(r'[a-z]').hasMatch(value)) return "Must contain lowercase";
                                if (!RegExp(r'[0-9]').hasMatch(value)) return "Must contain number";
                                return null;
                              },

                            ),
                          ],
                        ),
                      ), //password field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Confirm Password*',style: TextStyle(color: Colors.white),),
                            ),
                            TextFormField(
                              controller: confirmPasswordController,
                              style: TextStyle(color: Colors.white),
                              obscureText: confirmHidden,
                              decoration: InputDecoration(
                                hintText: '@12345#',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                                suffixIcon: IconButton(
                                  onPressed: (){confirmHidden=!confirmHidden;
                                  setState(() {
                                  });},
                                  icon: Icon(confirmHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), //confirm password field
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: BorderSide(color: Colors.grey,width: 2)
                            ),
                            onPressed: (){
                              _register();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login,color: Colors.white,size: 25,),
                                  SizedBox(width: 15,),
                                  Text('Sign up',style: TextStyle(fontSize: 17,color: Colors.white),),
                                ],
                              ),
                            )
                        ),
                      ),// sign up button
                    ],
                  ),
              ),

            ),
          ),
      ),
    );
  }
}

