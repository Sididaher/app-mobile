import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Inscription
  Future<UserModel?> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user == null) {
        throw Exception('Erreur lors de l\'inscription');
      }

      // Créer le profil utilisateur
      await _createUserProfile(
        userId: response.user!.id,
        email: email,
        fullName: fullName,
      );

      return _getUserFromSession();
    } catch (e) {
      rethrow;
    }
  }

  // Connexion
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return _getUserFromSession();
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer l'utilisateur actuel
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(profile);
    } catch (e) {
      return null;
    }
  }

  // Vérifier si l'utilisateur est connecté
  bool isUserLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Récupérer l'ID de l'utilisateur actuel
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  // Mettre à jour la photo de profil
  Future<String?> updateProfilePicture(File imageFile) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) return null;

      final fileName = '$userId-avatar-${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'avatars/$fileName';

      // Uploader l'image dans le bucket 'profile'
      await _supabase.storage.from('profile').upload(
            path,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Récupérer l'URL publique
      final String publicUrl = _supabase.storage.from('profile').getPublicUrl(path);

      // Mettre à jour le profil dans la base de données
      await updateProfile(avatarUrl: publicUrl);

      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le profil
  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) return;

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _supabase.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // Méthodes privées
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String fullName,
  }) async {
    await _supabase.from('profiles').insert({
      'id': userId,
      'email': email,
      'full_name': fullName,
    });
  }

  Future<UserModel?> _getUserFromSession() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(profile);
    } catch (e) {
      return null;
    }
  }
}
