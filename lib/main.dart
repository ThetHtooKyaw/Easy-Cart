import 'package:easy_cart/src/favourite/view_models/favourite_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/core/widgets/loading_column.dart';
import 'package:easy_cart/src/account/view_models/account_view_model.dart';
import 'package:easy_cart/src/auth/repo/auth_service.dart';
import 'package:easy_cart/src/order/repo/order_service.dart';
import 'package:easy_cart/src/order/view_models/order_history_view_model.dart';
import 'package:easy_cart/src/products/repo/product_service.dart';
import 'package:easy_cart/core/themes/app_theme.dart';
import 'package:easy_cart/firebase_options.dart';
import 'package:easy_cart/src/auth/view_models/login_view_model.dart';
import 'package:easy_cart/src/auth/view_models/signup_view_model.dart';
import 'package:easy_cart/src/auth/views/login_view.dart';
import 'package:easy_cart/src/cart/view_models/cart_view_model.dart';
import 'package:easy_cart/src/products/view_models/products_view_model.dart';
import 'package:easy_cart/core/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseAuth.instance.signOut();
  // await ProductMigrationService().migrateProducts();
  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => ProductService()),
        Provider(create: (_) => OrderService()),

        // ViewModels
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<SignUpViewModel>(
          create: (context) => SignUpViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<AccountViewModel>(
          create: (context) => AccountViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<ProductsViewModel>(
          create: (context) =>
              ProductsViewModel(context.read<ProductService>()),
        ),
        ChangeNotifierProvider<CartViewModel>(create: (_) => CartViewModel()),
        ChangeNotifierProvider<FavouriteViewModel>(
          create: (_) => FavouriteViewModel(),
        ),
        ChangeNotifierProvider<OrderHistoryViewModel>(
          create: (context) => OrderHistoryViewModel(
            context.read<OrderService>(),
            context.read<AuthService>(),
          ),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingColumn(message: 'App Loading');
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const BottomNavBar();
          }
          return const LoginView();
        },
      ),
    );
  }
}
