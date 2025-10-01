import 'package:flutter/material.dart';

Widget number_button(String number){
  return OutlinedButton(
      onPressed: (){},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.transparent)
      ),
      child: Text(number,style: TextStyle(color: Colors.white,fontSize: 25)),
  );
}