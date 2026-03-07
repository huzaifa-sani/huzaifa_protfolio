import 'package:flutter/material.dart';
import 'package:huzaifa_portfolio/home/first_home.dart';

void main() {
  runApp(const MainTo());
}

class MainTo extends StatelessWidget {
  const MainTo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'huzaifa_portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0A14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF7C4DFF),
        ),
        useMaterial3: true,
      ),
      home: const FirstHome(),
    );
  }
}