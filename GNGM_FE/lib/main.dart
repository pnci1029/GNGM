import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'constants/text_styles.dart';
import 'screens/home/home_screen.dart';
import 'screens/category/category_screen.dart';
import 'screens/request/request_detail_screen.dart';
import 'screens/request/create_request_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/profile_complete_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/request_provider.dart';
import 'providers/offer_provider.dart';
import 'providers/location_provider.dart';
import 'services/api_client_factory.dart';
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
    final apiClient = ApiClientFactory.create();
    final authService = AuthService(apiClient);
    final requestService = RequestService(apiClient);
    final offerService = OfferService(apiClient);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService, apiClient)),
        ChangeNotifierProvider(create: (_) => RequestProvider(requestService)),
        ChangeNotifierProvider(create: (_) => OfferProvider(offerService)),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
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
            home: _getHomeWidget(authProvider),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/profile-complete': (context) => const ProfileCompleteScreen(),
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

  Widget _getHomeWidget(AuthProvider authProvider) {
    // 초기화 중이면 무조건 스플래시 화면
    if (authProvider.isInitializing) {
      return _buildSplashScreen();
    }
    
    // 사용자가 없으면 로그인
    if (authProvider.user == null) {
      return const LoginScreen();
    }
    
    // 사용자가 있지만 프로필이 완성되지 않으면 프로필 완성 화면
    if (!authProvider.user!.hasCompleteProfile) {
      return const ProfileCompleteScreen();
    }
    
    // 모든 조건이 충족되면 홈 화면
    return const HomeScreen();
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GNGM 로고
            Text(
              'GNGM',
              style: AppTextStyles.brandTitle.copyWith(
                color: AppColors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '가는김에',
              style: AppTextStyles.title.copyWith(
                color: AppColors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            // 로딩 인디케이터
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

