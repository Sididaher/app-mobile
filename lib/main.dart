import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/main_home_screen.dart';
import 'screens/home/product_details_screen.dart';
import 'screens/home/categories_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'models/cart_item_model.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/settings_screen.dart';
import 'screens/profile/subpages/language_settings_screen.dart';
import 'screens/profile/subpages/theme_settings_screen.dart';
import 'screens/profile/subpages/notification_settings_screen.dart';
import 'screens/profile/subpages/security_settings_screen.dart';
import 'screens/profile/subpages/address_screen.dart';
import 'screens/profile/subpages/payment_methods_screen.dart';
import 'screens/profile/subpages/contact_us_screen.dart';
import 'screens/profile/subpages/documentation_screen.dart';
import 'core/config/language_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Initialiser Language Manager
  await LanguageManager().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager(),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AppAchats',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeManager().themeMode,
          home: const SplashScreen(),
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const MainHomeScreen(),
            '/orders': (context) => const OrdersScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/catalog': (context) => const CategoriesScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/settings/language': (context) => const LanguageSettingsScreen(),
            '/settings/theme': (context) => const ThemeSettingsScreen(),
            '/settings/notifications': (context) => const NotificationSettingsScreen(),
            '/settings/security': (context) => const SecuritySettingsScreen(),
            '/settings/address': (context) => const AddressScreen(),
            '/settings/payment': (context) => const PaymentMethodsScreen(),
            '/settings/contact': (context) => const ContactUsScreen(),
            '/settings/help': (context) => const DocumentationScreen(
              title: 'Help Center',
              content: 'Welcome to the AppAchats Help Center. We are here to assist you with any questions or issues you may have while using our platform...',
            ),
            '/settings/about': (context) => const DocumentationScreen(
              title: 'About AppAchats',
              content: 'AppAchats is Mauritania’s premier luxury e-commerce platform, dedicated to bringing the world’s finest products directly to your doorstep...',
            ),
            '/settings/privacy': (context) => const DocumentationScreen(
              title: 'Privacy Policy',
              content: 'At AppAchats, we take your privacy seriously. This policy describes how we collect, use, and handle your personal information...',
            ),
            '/settings/terms': (context) => const DocumentationScreen(
              title: 'Terms & Conditions',
              content: 'By using AppAchats, you agree to comply with and be bound by the following terms and conditions of use...',
            ),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/checkout') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => CheckoutScreen(
                  cartItems: args['cartItems'] as List<CartItemModel>,
                  total: args['total'] as double,
                ),
              );
            }
            if (settings.name == '/product_details') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  product: args['product'],
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
