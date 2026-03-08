import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const FirstHome(),
    );
  }
}