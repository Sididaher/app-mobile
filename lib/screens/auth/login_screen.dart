import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/skeleton_widget.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de connexion : identifiants incorrects';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Logo text
              const Text(
                'APPACHAT',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4.0,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 40),
              // Welcome text
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please enter your credentials to access your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // Email Field
              _buildLabel('EMAIL ADDRESS', isDark),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'name@atelier.com',
                ),
              ),
              const SizedBox(height: 24),

              // Password Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('PASSWORD', isDark),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'FORGOT PASSWORD?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],

              const SizedBox(height: 40),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: SkeletonWidget.circular(size: 24),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Sign In'),
                            SizedBox(width: 12),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 48),
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 32),

              // Social Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildSocialButton(
                      label: 'Google',
                      iconPath: 'assets/images/login/google.png',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSocialButton(
                      label: 'Apple',
                      icon: Icons.apple,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        if (Navigator.canPop(context))
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
      ],
    ),
  ),
);
  }

  Widget _buildLabel(String text, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Colors.grey.shade700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSocialButton({required String label, String? iconPath, IconData? icon, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null)
            Image.network('https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg', height: 24) // Placeholder placeholder
          else if (icon != null)
            Icon(icon, size: 24, color: isDark ? Colors.white : Colors.black),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
