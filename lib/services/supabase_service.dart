import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Singleton pattern
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Get Supabase client
  SupabaseClient get client => Supabase.instance.client;

  // Check if user is logged in
  bool get isLoggedIn => client.auth.currentUser != null;

  // Get current user
  User? get currentUser => client.auth.currentUser;

  // Get user ID
  String? get userId => currentUser?.id;

  // Get user email
  String? get userEmail => currentUser?.email;

  // Get user name from metadata
  String? get userName => currentUser?.userMetadata?['full_name'];

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
  Future<AuthResponse> signInWithPassword({
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

  // ==================== PROFILE ====================

  // Get user profile
  Future<Map<String, dynamic>?> getProfile() async {
    if (userId == null) return null;

    final response =
        await client.from('profiles').select().eq('id', userId!).maybeSingle();

    return response;
  }

  // Update user profile
  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    if (userId == null) throw Exception('User not logged in');

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) updates['full_name'] = fullName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await client.from('profiles').update(updates).eq('id', userId!);
  }
}
