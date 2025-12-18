import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Singleton pattern
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Supabase client
  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  // Get current user
  User? get currentUser => client.auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Get user ID
  String? get userId => currentUser?.id;

  // Get user email
  String? get userEmail => currentUser?.email;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ==================== AUTHENTICATION ====================

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  // Update user profile
  Future<UserResponse> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    return await client.auth.updateUser(
      UserAttributes(data: updates),
    );
  }

  // ==================== PROFILES ====================

  // Get user profile
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response =
        await client.from('profiles').select().eq('id', userId).maybeSingle();
    return response;
  }

  // Update profile in database
  Future<void> updateProfileData({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (fullName != null) updates['full_name'] = fullName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await client.from('profiles').update(updates).eq('id', userId);
  }

  // ==================== CATEGORIES ====================

  // Get all categories for user
  Future<List<Map<String, dynamic>>> getCategories() async {
    if (userId == null) return [];

    final response = await client
        .from('categories')
        .select()
        .eq('user_id', userId!)
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  // Get categories by type
  Future<List<Map<String, dynamic>>> getCategoriesByType(String type) async {
    if (userId == null) return [];

    final response = await client
        .from('categories')
        .select()
        .eq('user_id', userId!)
        .eq('type', type)
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  // Create category
  Future<Map<String, dynamic>> createCategory({
    required String name,
    required String type,
    String? icon,
    String? color,
  }) async {
    if (userId == null) throw Exception('User not logged in');

    final response = await client
        .from('categories')
        .insert({
          'user_id': userId,
          'name': name,
          'type': type,
          'icon': icon,
          'color': color,
        })
        .select()
        .single();

    return response;
  }

  // Update category
  Future<void> updateCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? color,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (icon != null) updates['icon'] = icon;
    if (color != null) updates['color'] = color;

    await client.from('categories').update(updates).eq('id', categoryId);
  }

  // Delete category
  Future<void> deleteCategory(String categoryId) async {
    await client.from('categories').delete().eq('id', categoryId);
  }

  // ==================== TRANSACTIONS ====================

  // Get all transactions for user
  Future<List<Map<String, dynamic>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (userId == null) return [];

    var query = client
        .from('transactions')
        .select('*, categories(*)')
        .eq('user_id', userId!);

    if (startDate != null) {
      query = query.gte('date', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('date', endDate.toIso8601String());
    }

    final response = await query.order('date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Get transactions by type
  Future<List<Map<String, dynamic>>> getTransactionsByType(
    String type, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (userId == null) return [];

    var query = client
        .from('transactions')
        .select('*, categories(*)')
        .eq('user_id', userId!)
        .eq('type', type);

    if (startDate != null) {
      query = query.gte('date', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('date', endDate.toIso8601String());
    }

    final response = await query.order('date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Create transaction
  Future<Map<String, dynamic>> createTransaction({
    required String categoryId,
    required double amount,
    required String type,
    required DateTime date,
    String? description,
  }) async {
    if (userId == null) throw Exception('User not logged in');

    final response = await client
        .from('transactions')
        .insert({
          'user_id': userId,
          'category_id': categoryId,
          'amount': amount,
          'type': type,
          'date': date.toIso8601String(),
          'description': description,
        })
        .select()
        .single();

    return response;
  }

  // Update transaction
  Future<void> updateTransaction({
    required String transactionId,
    String? categoryId,
    double? amount,
    DateTime? date,
    String? description,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (categoryId != null) updates['category_id'] = categoryId;
    if (amount != null) updates['amount'] = amount;
    if (date != null) updates['date'] = date.toIso8601String();
    if (description != null) updates['description'] = description;

    await client.from('transactions').update(updates).eq('id', transactionId);
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    await client.from('transactions').delete().eq('id', transactionId);
  }

  // Get transaction statistics
  Future<Map<String, double>> getTransactionStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await getTransactions(
      startDate: startDate,
      endDate: endDate,
    );

    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in transactions) {
      final amount = (transaction['amount'] as num).toDouble();
      if (transaction['type'] == 'income') {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
    }

    return {
      'income': totalIncome,
      'expense': totalExpense,
      'balance': totalIncome - totalExpense,
    };
  }

  // ==================== BUDGETS ====================

  // Get all budgets for user
  Future<List<Map<String, dynamic>>> getBudgets() async {
    if (userId == null) return [];

    final response = await client
        .from('budgets')
        .select('*, categories(*)')
        .eq('user_id', userId!)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Create budget
  Future<Map<String, dynamic>> createBudget({
    required String categoryId,
    required double amount,
    required String period,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    if (userId == null) throw Exception('User not logged in');

    final response = await client
        .from('budgets')
        .insert({
          'user_id': userId,
          'category_id': categoryId,
          'amount': amount,
          'period': period,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
        })
        .select()
        .single();

    return response;
  }

  // Update budget
  Future<void> updateBudget({
    required String budgetId,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final updates = <String, dynamic>{};
    if (amount != null) updates['amount'] = amount;
    if (startDate != null) updates['start_date'] = startDate.toIso8601String();
    if (endDate != null) updates['end_date'] = endDate.toIso8601String();

    await client.from('budgets').update(updates).eq('id', budgetId);
  }

  // Delete budget
  Future<void> deleteBudget(String budgetId) async {
    await client.from('budgets').delete().eq('id', budgetId);
  }

  // ==================== RECURRING TRANSACTIONS ====================

  // Get all recurring transactions
  Future<List<Map<String, dynamic>>> getRecurringTransactions() async {
    if (userId == null) return [];

    final response = await client
        .from('recurring_transactions')
        .select('*, categories(*)')
        .eq('user_id', userId!)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Create recurring transaction
  Future<Map<String, dynamic>> createRecurringTransaction({
    required String categoryId,
    required double amount,
    required String type,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
  }) async {
    if (userId == null) throw Exception('User not logged in');

    final response = await client
        .from('recurring_transactions')
        .insert({
          'user_id': userId,
          'category_id': categoryId,
          'amount': amount,
          'type': type,
          'frequency': frequency,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
          'description': description,
          'is_active': true,
        })
        .select()
        .single();

    return response;
  }

  // Update recurring transaction
  Future<void> updateRecurringTransaction({
    required String recurringId,
    double? amount,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? description,
  }) async {
    final updates = <String, dynamic>{};
    if (amount != null) updates['amount'] = amount;
    if (frequency != null) updates['frequency'] = frequency;
    if (startDate != null) updates['start_date'] = startDate.toIso8601String();
    if (endDate != null) updates['end_date'] = endDate.toIso8601String();
    if (isActive != null) updates['is_active'] = isActive;
    if (description != null) updates['description'] = description;

    await client
        .from('recurring_transactions')
        .update(updates)
        .eq('id', recurringId);
  }

  // Delete recurring transaction
  Future<void> deleteRecurringTransaction(String recurringId) async {
    await client.from('recurring_transactions').delete().eq('id', recurringId);
  }
}
