import 'package:bankapp/screens/register.dart';
import 'package:bankapp/screens/sign_in.dart';
import 'package:flutter/material.dart';

class welcome_page extends StatelessWidget {
  const welcome_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/5825273.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Image.asset('assets/images/logo.png',width: 150,height: 150,)
            ), //logo
            Expanded(
                child: Column(
                  children: [
                    Text(
                    'SMART BANKING STARTS HERE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontStyle: FontStyle.italic,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                    Text(
                      'Your money\nYour future',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    Text(
                      'Simplified',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontStyle: FontStyle.italic,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    Text(
                      'With',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    Text(
                      'BANKY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontStyle: FontStyle.italic,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE9C1F6),
                        height: 1.3,
                      ),
                    ),
                  ]
                ),
              ), // text
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: Colors.grey,width: 2)
                  ),
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>sign_in()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward,color: Colors.white,size: 25,),
                        SizedBox(width: 15,),
                        Text('Continue',style: TextStyle(fontSize: 17,color: Colors.white),),
                      ],
                    ),
                  )
              ),
            ), // continue button

          ],
        ),

      ),
    );
  }
}

