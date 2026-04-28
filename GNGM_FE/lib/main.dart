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
        primarySwatch: Colors.blue,
        primaryColor: GNGMColors.trustBlue,
        scaffoldBackgroundColor: GNGMColors.backgroundColor,
        fontFamily: GNGMTextStyles.fontFamily,
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

