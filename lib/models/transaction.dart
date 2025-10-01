class Transaction{
  late String receiver;
  late String desc;
  late double value;
  DateTime date;

  Transaction({
    required this.receiver,
    required this.desc,
    required this.value,
    required this.date
  });


  Map<String, dynamic> toJson() {
    return {
      'receiver': receiver,
      'description': desc,
      'amount': value,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      receiver: json['receiver'] ?? '',
      desc: json['description'] ?? '',
      value: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }




}