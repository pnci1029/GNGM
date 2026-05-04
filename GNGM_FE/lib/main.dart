import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'constants/text_styles.dart';
import 'screens/home/home_screen.dart';
import 'screens/category/category_screen.dart';
import 'screens/request/request_detail_screen.dart';
import 'screens/request/create_request_screen.dart';
import 'screens/auth/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/request_provider.dart';
import 'providers/offer_provider.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'services/request_service.dart';
import 'services/offer_service.dart';

void main() {
  runApp(const GNGMApp());
}

class GNGMApp extends StatelessWidget {
  const GNGMApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final authService = AuthService(apiClient);
    final requestService = RequestService(apiClient);
    final offerService = OfferService(apiClient);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService, apiClient)),
        ChangeNotifierProvider(create: (_) => RequestProvider(requestService)),
        ChangeNotifierProvider(create: (_) => OfferProvider(offerService)),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'GNGM',
            theme: ThemeData(
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.background,
              fontFamily: 'Pretendard',
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen(),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/create-request': (context) => const CreateRequestScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/category') {
                final categoryType = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (context) => CategoryScreen(categoryType: categoryType),
                );
              }
              if (settings.name == '/request-detail') {
                final requestId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (context) => RequestDetailScreen(requestId: requestId),
                );
              }
              return null;
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

