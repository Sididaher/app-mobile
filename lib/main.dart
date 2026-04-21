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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

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
