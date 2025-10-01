import 'package:bankapp/screens/register.dart';
import 'package:bankapp/screens/user_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class sign_in extends StatefulWidget {
  @override
  State<sign_in> createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  bool hidden=true;
  bool _checked=false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an email ")),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the password ")),
      );
      return;
    }





    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      _checked
          ? Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => user_home()),
      )
          : Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => user_home()),
      );

    } on FirebaseAuthException catch (e) {
      String message = "Invalid credentials entered";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  } // login authentication




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF350035),Colors.black],begin: Alignment.topRight,end: Alignment.bottomCenter)
        ), // color gradient
        height: double.infinity,
        width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:50),
                ), // top spacing
                Center(
                    child: Image.asset('assets/images/logo.png',height: 100,width: 100,)
                ), // logo
                Padding(
                  padding: const EdgeInsets.only(top:50),
                ), // spacing between logo and text
                Center(
                  child: Text('Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Ubuntu',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
            
                    ),
                  ),
                ), //welcome back
                Center(
                  child: Text('Please enter your credentials',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Ubuntu',
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF6C6865)
            
                    ),
                  ),
                ), //subtext
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Email Address',style: TextStyle(color: Colors.white),),
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
                ), //email address field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Password',style: TextStyle(color: Colors.white),),
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
                      ),
                    ],
                  ),
                ), //password field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                          Text('Remember me',style: TextStyle(color: Colors.white),
                          ),
                          Checkbox(
                              value: _checked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _checked = newValue ?? false;
                                });
                              }),],
                        ),
                      ), //remember me
                      InkWell(
                        child: Text('Forgot password?',style: TextStyle(color: Colors.white,decoration: TextDecoration.underline,decorationColor: Colors.white),
                        ),
                        onTap: (){},
                      ), //forgot password

                    ],
                  ),
                ), // remember me and forgot password
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.grey,width: 2)
                    ),
                      onPressed: (){
                       _login();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login,color: Colors.white,size: 25,),
                            SizedBox(width: 15,),
                            Text('Sign in',style: TextStyle(fontSize: 17,color: Colors.white),),
                          ],
                        ),
                      )
                  ),
                ), // sign in button
                Padding(
                  padding: const EdgeInsets.only(top:100),
                ), // spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Dont have an account?',style: TextStyle(color: Colors.white)
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      child: Text('Register',style: TextStyle(color: Colors.white,decorationColor: Colors.white,decoration: TextDecoration.underline)),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>register()));
                      },
                    ),
                  ],
                ), // register direct
            
                ]
            ),
          ),
      ),
    ),
    );
  }
}
