import 'package:flutter/material.dart';
import '../../widgets/skeleton_widget.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // ✅ NE PAS BLOQUER - Charger Home directement (accès public)
    // L'auth sera vérifiée en background pour les actions protégées
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 80),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo - Shopping bag in circle
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.shade600,
                          width: 6,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          size: 100,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    // ShopSphere Title
                    const Text(
                      'ShopSphere',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E40AF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tagline
                    const Text(
                      'Your daily dose of style.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              // Loading indicator at the bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: const SkeletonWidget.circular(size: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
