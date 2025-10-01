import 'package:flutter/material.dart';

Widget actionButton(IconData icon, String label,VoidCallback onPress) {
  return Column(
    children: [
     OutlinedButton(
     style: OutlinedButton.styleFrom(
       minimumSize: Size(200, 80),
     shape: CircleBorder(),
     side: BorderSide(color: Colors.white),
     backgroundColor: Colors.transparent
  ), onPressed: onPress, child: Icon(icon,color: Colors.white,size: 30,),
     ),
      Padding(padding: const EdgeInsets.only(top:10)),
     Text(label,style: TextStyle(color: Colors.white,fontSize: 15),),
      
  
    ],
  );
}
