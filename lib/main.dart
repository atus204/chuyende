import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/splash/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/food_detail/food_detail_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/checkout/order_success_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/admin/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const NhaBepVietApp());
}

class NhaBepVietApp extends StatelessWidget {
  const NhaBepVietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Nhà Bếp Việt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.onboarding: (_) => const OnboardingScreen(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.register: (_) => const RegisterScreen(),
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.menu: (_) => const MenuScreen(),
          AppRoutes.foodDetail: (_) => const FoodDetailScreen(),
          AppRoutes.cart: (_) => const CartScreen(),
          AppRoutes.checkout: (_) => const CheckoutScreen(),
          AppRoutes.orderSuccess: (_) => const OrderSuccessScreen(),
          AppRoutes.orders: (_) => const OrdersScreen(),
          AppRoutes.profile: (_) => const ProfileScreen(),
          AppRoutes.admin: (_) => const AdminScreen(),
        },
      ),
    );
  }
}
