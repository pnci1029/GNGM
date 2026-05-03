import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/category/category_screen.dart';
import '../screens/request/request_detail_screen.dart';
import '../screens/request/create_request_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String category = '/category';
  static const String requestDetail = '/request-detail';
  static const String createRequest = '/create-request';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      category: (context) => const CategoryScreen(),
      requestDetail: (context) => const RequestDetailScreen(),
      createRequest: (context) => const CreateRequestScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case category:
        final category = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => CategoryScreen(category: category),
        );
        
      case requestDetail:
        final requestId = settings.arguments as String?;
        if (requestId == null) {
          return MaterialPageRoute(
            builder: (context) => const _ErrorScreen(
              message: '요청 ID가 필요합니다.',
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => RequestDetailScreen(requestId: requestId),
        );
        
      default:
        return MaterialPageRoute(
          builder: (context) => const _ErrorScreen(
            message: '페이지를 찾을 수 없습니다.',
          ),
        );
    }
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  
  const _ErrorScreen({required this.message});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오류'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}