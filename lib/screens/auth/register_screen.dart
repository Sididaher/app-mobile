import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/skeleton_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_agreeToTerms) {
      setState(() => _errorMessage = 'Veuillez accepter les conditions');
      return;
    }

    if (_fullNameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur d\'inscription : ${e.toString()}';
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
      body: Stack(
        children: [
          // Background Header (Placeholder for the image in the design)
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=1000&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'APPACHAT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Form Content
          Padding(
            padding: const EdgeInsets.only(top: 220),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const Text(
                          'STEP 01/02',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(height: 2, width: 120, color: Colors.orange.shade300),
                    const SizedBox(height: 32),

                    _buildLabel('Full Name', isDark),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(hintText: 'Evelyn Thorne'),
                    ),
                    const SizedBox(height: 24),

                    _buildLabel('Email Address', isDark),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'evelyn@atelier.com'),
                    ),
                    const SizedBox(height: 24),

                    _buildLabel('Security Code', isDark),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
                    Text(
                      'Must contain at least 8 characters, including one uppercase letter and a symbol.',
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),

                    // Terms Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                          activeColor: AppTheme.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 13),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: isDark ? AppTheme.accentGold : Colors.black),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: isDark ? AppTheme.accentGold : Colors.black),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: SkeletonWidget.circular(size: 24),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Continue to Preferences'),
                                  SizedBox(width: 12),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'OR JOIN WITH',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildSocialButton(
                            label: 'Google',
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white70 : Colors.grey.shade700,
      ),
    );
  }

  Widget _buildSocialButton({required String label, IconData? icon, required bool isDark}) {
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
          if (icon != null) Icon(icon, size: 24, color: isDark ? Colors.white : Colors.black) else Icon(Icons.g_mobiledata, size: 28, color: isDark ? Colors.white : Colors.black),
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
