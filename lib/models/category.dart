import 'package:flutter/material.dart';

class Category {
  final String id;
  final String userId;
  final String name;
  final IconData icon;
  final Color color;
  final String type; // 'income' or 'expense'
  final bool isDefault;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.isDefault = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      icon: IconData(json['icon_code'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] as int),
      type: json['type'] as String,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'icon_code': icon.codePoint,
      'color': color.value,
      'type': type,
      'is_default': isDefault,
    };
  }

  // Default categories
  static List<Category> getDefaultExpenseCategories(String userId) {
    return [
      Category(
        id: 'cat_general',
        userId: userId,
        name: 'Gastos Generales',
        icon: Icons.shopping_cart,
        color: const Color(0xFF4CAF50),
        type: 'expense',
        isDefault: true,
      ),
      Category(
        id: 'cat_food',
        userId: userId,
        name: 'Comida',
        icon: Icons.restaurant,
        color: const Color(0xFFFF9800),
        type: 'expense',
        isDefault: true,
      ),
      Category(
        id: 'cat_transport',
        userId: userId,
        name: 'Transporte',
        icon: Icons.directions_car,
        color: const Color(0xFF2196F3),
        type: 'expense',
        isDefault: true,
      ),
      Category(
        id: 'cat_entertainment',
        userId: userId,
        name: 'Entretenimiento',
        icon: Icons.movie,
        color: const Color(0xFF9C27B0),
        type: 'expense',
        isDefault: true,
      ),
      Category(
        id: 'cat_health',
        userId: userId,
        name: 'Salud',
        icon: Icons.local_hospital,
        color: const Color(0xFFE53935),
        type: 'expense',
        isDefault: true,
      ),
      Category(
        id: 'cat_utilities',
        userId: userId,
        name: 'Servicios',
        icon: Icons.bolt,
        color: const Color(0xFFFFEB3B),
        type: 'expense',
        isDefault: true,
      ),
    ];
  }

  static List<Category> getDefaultIncomeCategories(String userId) {
    return [
      Category(
        id: 'cat_salary',
        userId: userId,
        name: 'Salario',
        icon: Icons.account_balance_wallet,
        color: const Color(0xFF4CAF50),
        type: 'income',
        isDefault: true,
      ),
      Category(
        id: 'cat_freelance',
        userId: userId,
        name: 'Freelance',
        icon: Icons.work,
        color: const Color(0xFF2196F3),
        type: 'income',
        isDefault: true,
      ),
      Category(
        id: 'cat_investment',
        userId: userId,
        name: 'Inversiones',
        icon: Icons.trending_up,
        color: const Color(0xFF9C27B0),
        type: 'income',
        isDefault: true,
      ),
    ];
  }
}
