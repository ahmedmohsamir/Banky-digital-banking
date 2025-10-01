import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:bankapp/models/transaction.dart';

class transfer extends StatefulWidget {
  const transfer({super.key});

  @override
  State<transfer> createState() => _transferPageState();
}

class _transferPageState extends State<transfer> {
  Map<String, dynamic>? userData;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final currentUser = auth.FirebaseAuth.instance.currentUser;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<void> finalizeTransfer() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final double amount = double.tryParse(amountController.text) ?? 0;
    final String recipientUsername = recipientController.text.trim();
    final String description = descController.text.trim();

    if (amount <= 0 || recipientUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter valid amount and recipient username")),
      );
      return;
    }

    final senderDoc = FirebaseFirestore.instance.collection("users").doc(user.uid);
    final senderSnapshot = await senderDoc.get();
    final senderData = senderSnapshot.data()!;

    if (senderData['balance'] < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insufficient balance")),
      );
      return;
    }

    // find recipient by username
    final recipientQuery = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: recipientUsername)
        .get();

    if (recipientQuery.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Recipient not found")),
      );
      return;
    }

    final recipientDoc = recipientQuery.docs.first.reference;
    final recipientData = recipientQuery.docs.first.data();

    final tx = Transaction(
      receiver: recipientUsername,
      desc: description,
      value: amount,
      date: DateTime.now(),
    ).toJson();

    final txReceiver = Transaction(
      receiver: senderData['username'],
      desc: description,
      value: amount,
      date: DateTime.now(),
    ).toJson();

    // update balances + transactions
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(senderDoc, {
        "balance": senderData['balance'] - amount,
        "transactions": FieldValue.arrayUnion([tx]),
      });

      transaction.update(recipientDoc, {
        "balance": recipientData['balance'] + amount,
        "transactions": FieldValue.arrayUnion([txReceiver]),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Transfer successful")),
    );

    Navigator.pop(context);
  }
  Future<void> _loadUserData() async {
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get();

    if (snapshot.exists) {
      setState(() {
        userData = snapshot.data();
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
         gradient: LinearGradient(colors: [Colors.black,Color(0xFF1A0000),],
           begin:Alignment.topLeft ,
           end: Alignment.bottomLeft
         ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Text(
                  "Transfer Money",
                  style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE9C1F6)
                  ),
                ),
                const SizedBox(height: 40),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "\$",
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: amountController,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 36),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "0.0",
                          hintStyle:
                          TextStyle(color: Colors.white54, fontSize: 36),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ), // amount
                const SizedBox(height: 12),
                const Text(
                  "Enter amount to send",
                  style: TextStyle(color: Colors.white54),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      const Text("Transfer From",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white70)), // transfer from
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.white.withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                            title:  Text('${userData?['name']}',
                                style: TextStyle(color: Colors.white)),
                            subtitle:  Text('@${userData?['username']}',
                                style: TextStyle(color: Colors.white54)),
                            trailing:  Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('current balance',style: TextStyle(color: Colors.white),),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('\$',style: TextStyle(fontSize: 20,color: Colors.white)),
                                    Text('${userData?['balance']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white)),
                                  ],
                                ),
                              ],
                            )
                        ),
                      ),  // sender info

                      const SizedBox(height: 20),


                      const Text("Transfer To",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white70)), // transfer to
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: recipientController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter recipient username",
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                      ), // recipient username
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: descController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Add description",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                      ), // description
                    ],
                  ),
                ), // transfer block

                const SizedBox(height: 40),

                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      side: BorderSide(
                        color: Colors.white,
                      )
                    ),
                    onPressed: () {
                      finalizeTransfer();
                    },
                      child: Text('Finalize Transfer',style: TextStyle(fontSize: 20,color: Color(0xFFE9C1F6)),),
                  ),
                ), // submit button
                SizedBox(height: 100),
                Image.asset(
                  "assets/images/logo.png",
                  height: 60,
                  width: 150,
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
