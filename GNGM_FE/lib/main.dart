import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/text_styles.dart';
import 'screens/home/home_screen.dart';
import 'screens/category/category_screen.dart';
import 'screens/request/request_detail_screen.dart';
import 'screens/request/create_request_screen.dart';

void main() {
  runApp(const GNGMApp());
}

class GNGMApp extends StatelessWidget {
  const GNGMApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
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
  }
}

