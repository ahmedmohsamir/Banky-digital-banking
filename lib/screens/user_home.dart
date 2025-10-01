import 'package:bankapp/models/transaction.dart';
import 'package:bankapp/screens/all_transactions.dart';
import 'package:bankapp/screens/sign_in.dart';
import 'package:bankapp/screens/top_up.dart';
import 'package:bankapp/screens/transfer.dart';
import 'package:bankapp/screens/welcome_page.dart';
import 'package:bankapp/screens/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:bankapp/widgets/user_home/actionButton.dart';
import 'package:bankapp/widgets/user_home/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;




class user_home extends StatefulWidget {
  const user_home({super.key});

  @override
  State<user_home> createState() => _user_homeState();
}

class _user_homeState extends State<user_home> {
  bool hidden=false;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  Map<String, dynamic>? userData;
  bool isLoading = true;


  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      setState(() {
        userData = doc.data();
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black,Color(0XFF1A0000)],begin: Alignment.topCenter,end: Alignment.bottomLeft)
            ),
            child: Column(
              children: [
                ListTile(title:
                Text(
                  'Welcome back ${userData?['name'] }!',
                  style: TextStyle(color: Colors.white),
                ),
                    subtitle: Text('Lets take a look at your finances.',style: TextStyle(color: Colors.white)),
                    trailing: IconButton(
                        onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.logout,color: Colors.white,size: 30,))
                  ), // welcome back & logout
                Container(
                  width: double.infinity,
                    color: Colors.transparent,
                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsets.only(top:15)),
                          Text('Current balance',style: TextStyle(color: Color(0xFF525053),fontSize: 20),),
                          Text('\$${userData?['balance'] }',style: TextStyle(color: Colors.white,fontSize: 40)),

                        ],
                      )

                ), // balance
                Padding(
                    padding: const EdgeInsets.only(top:50)
                ), // spacing
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      actionButton(Icons.arrow_upward_rounded, 'Transfer',()async{
                        await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>transfer()),);
                        await fetchUserData();
                      }),
                      actionButton(Icons.arrow_downward, 'Withdraw',()async{
                        await Navigator.push(context, MaterialPageRoute(builder: (context)=>withdraw()));
                        await fetchUserData();
                      }),
                    ],
                  ),
                ), // transfer & withdraw buttons
                Padding(
                    padding: const EdgeInsets.only(top:10)
                ), //spacing
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      actionButton(Icons.add_card_outlined, 'Top up',() async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => topUp()),
                        );
                        await fetchUserData();
                      }), // deposit money
                      actionButton(Icons.history, 'Transactions', (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>all_transaction()));
                          }
                      ),
                    ],
                  ),
                ), // top up & transactions buttons
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ), // recent transaction text
                Expanded(
                  child: userData?['transactions'] == null
                      ? Center(child: Text("No transactions yet", style: TextStyle(color: Colors.white54)))
                      : ListView(
                    children: (userData!['transactions'] as List)
                        .reversed
                        .map((tx) => transaction_card(
                      Transaction.fromJson(Map<String, dynamic>.from(tx)),
                    ))
                        .toList(),
                  ),
                ), // transaction list
              ],
            ),
          )
      ),
    );
  }
}






