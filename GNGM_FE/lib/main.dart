import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/text_styles.dart';
import 'screens/main_screen.dart';

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
        primarySwatch: Colors.orange,
        primaryColor: GNGMColors.primary,
        scaffoldBackgroundColor: GNGMColors.backgroundColor,
        fontFamily: GNGMTextStyles.fontFamilyBase,
        colorScheme: ColorScheme.fromSeed(
          seedColor: GNGMColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

