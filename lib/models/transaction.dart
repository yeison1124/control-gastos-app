class Transaction {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final String type; // 'income' or 'expense'
  final String description;
  final DateTime date;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
