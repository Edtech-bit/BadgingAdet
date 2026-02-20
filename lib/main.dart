import 'package:flutter/material.dart';
import 'screens/homescreen.dart';

void main() {
  runApp(const DailyHelperApp());
}

class DailyHelperApp extends StatelessWidget {
  const DailyHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Helper Toolkit',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}