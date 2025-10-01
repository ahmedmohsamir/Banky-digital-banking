import 'package:bankapp/models/transaction.dart';
import 'package:bankapp/widgets/user_home/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

class all_transaction extends StatefulWidget {
  const all_transaction({super.key});

  @override
  State<all_transaction> createState() => _all_transactionState();
}

class _all_transactionState extends State<all_transaction> {

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }


  Map<String, dynamic>? userData;
  Future<void> fetchUserData() async {
    final user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      setState(() {
        userData = doc.data();
      });
    }
  }
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor:Colors.black ,
        title: Text('Transaction History',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black,Color(0XFF1A0000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft)
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Recipient',
                          suffixIcon: Icon(Icons.search_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                        ),
                        onChanged: (value) {
                         setState(() {
                           searchQuery = value.toLowerCase();
                          });}
                      ),
                    ],
                  ),
                ),// search field
                if (userData?['transactions'] == null)
                  Text("No transactions yet", style: TextStyle(color: Colors.white54))
                else
                  for (var tx in (userData!['transactions'] as List).reversed)
                    if ((tx['receiver'] ?? '').toString().toLowerCase().contains(searchQuery) ||
                        (tx['description'] ?? '').toString().toLowerCase().contains(searchQuery))
                      transaction_card(Transaction.fromJson(Map<String, dynamic>.from(tx)))
              ],
            ),
          ),
        ),

      ),
    );
  }
}
