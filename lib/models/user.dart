import 'package:bankapp/models/transaction.dart';

class User{
late String name;
late String username;
late String email;
late double balance;
List<Transaction> transactions=[];

User({
  required this.name,
  required this.username,
  required this.email,
  required this.balance,
  this.transactions=const[]
});


Map<String, dynamic> toJson() {
  return {
    'name': name,
    'username': username,
    'email': email,
    'balance': balance,
    'transactions': transactions.map((t) => t.toJson()).toList(),
  };



}

factory User.fromJson(Map<String, dynamic> json) {
  return User(
    name: json['name'],
    username: json['username'],
    email: json['email'],
    balance: (json['balance'] as num).toDouble(),
    transactions: (json['transactions'] as List<dynamic>? ?? [])
        .map((t) => Transaction.fromJson(t))
        .toList(),
  );
}


}