import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_required_dialog.dart';

/// Auth Guard Helper - Vérifie l'authentification et affiche un dialog si nécessaire
class AuthGuard {
  static final AuthService _authService = AuthService();

  /// Vérifier si utilisateur est connecté
  /// Si pas connecté, affiche un dialog avec options login/register
  static Future<bool> checkAuthAndShowDialog(BuildContext context) async {
    final isLoggedIn = _authService.isUserLoggedIn();

    if (!isLoggedIn) {
      if (context.mounted) {
        showAuthRequiredDialog(context);
      }
      return false;
    }
    return true;
  }

  /// Affiche le dialog d'authentification
  static void showAuthRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AuthRequiredDialog(),
    );
  }

  /// Vérifier si utilisateur est connecté (synchrone)
  static bool isUserLoggedIn() {
    return _authService.isUserLoggedIn();
  }
}
