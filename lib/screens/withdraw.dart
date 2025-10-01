import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class withdraw extends StatefulWidget {
  const withdraw({super.key});

  @override
  State<withdraw> createState() => _withdrawPageState();
}

class _withdrawPageState extends State<withdraw> {
  final currentUser = auth.FirebaseAuth.instance.currentUser;
  final amountController = TextEditingController();
  final descController = TextEditingController();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  Future<void> _withdrawMoney() async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
    final desc = descController.text.trim();

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid withdrawal amount")),
      );
      return;
    }

    try {
      final userDoc = FirebaseFirestore.instance.collection("users").doc(uid);

      await FirebaseFirestore.instance.runTransaction((txn) async {
        final snapshot = await txn.get(userDoc);

        if (!snapshot.exists) throw Exception("User not found");

        final currentBalance = snapshot["balance"] ?? 0.0;
        if (currentBalance < amount) {
          throw Exception("Insufficient funds");
        }

        final newBalance = currentBalance - amount;

        txn.update(userDoc, {
          "balance": newBalance,
          "transactions": FieldValue.arrayUnion([
            {
              "receiver": "withdrawal",
              "amount": amount,
              "description": desc,
              "date": DateTime.now().toIso8601String(),
            }
          ])
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Withdrawal successful ✅")),
      );
      Navigator.pop(context);
      await _loadUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A0000),
        iconTheme: IconThemeData(color: Color(0xFFE9C1F6)),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A0000),Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Withdraw Money",
                  style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE9C1F6)
                  ),
                ), // title
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "\$",
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ), // $
                    const SizedBox(width: 2),
                    SizedBox(
                      width: 140,
                      child: TextFormField(
                        controller: amountController,
                        textAlign: TextAlign.center,
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
                    ), // amount
                  ],
                ), // amount text field
                const SizedBox(height: 12),
                const Text(
                  "Enter amount to withdraw",
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

                      const Text("Withdraw from",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white70)), // Withdraw from
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
                      ), // user info

                      const SizedBox(height: 20),
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
                ), // withdraw block
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
                          color: Color(0xFFE9C1F6),
                        )
                    ),
                    onPressed: () {
                      _withdrawMoney();
                    },
                    child: Text('Withdraw Money',style: TextStyle(fontSize: 20,color: Color(0xFFE9C1F6)),),
                  ),), // submit button
                SizedBox(height: 170),
                Image.asset(
                  "assets/images/logo.png",
                  height: 60,
                  width: 150,
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
