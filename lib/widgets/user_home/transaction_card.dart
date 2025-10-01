

import 'package:bankapp/models/transaction.dart';
import 'package:flutter/material.dart';

Widget transaction_card(Transaction t ) {
  return InkWell(
    splashColor: Colors.white,
    highlightColor:Colors.white,
    onTap: (){},
    child: Card(
      color: Color(0xFF1f122b),
      child: ListTile(
        leading: Icon(Icons.compare_arrows_outlined,color: Colors.white,),
        title: Text(t.receiver,style: TextStyle(color: Colors.white),),
        subtitle: Text(t.desc,style: TextStyle(color: Colors.white),),
        trailing: Text('\$${t.value.toString()}',style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: Colors.white),),

      ),
    ),
  );
}
