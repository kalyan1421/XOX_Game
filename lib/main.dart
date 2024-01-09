import 'package:flutter/material.dart';
import 'package:xoxgame/player_details.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _continerWidth = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _continerWidth = 250;
      });
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Player_details()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BounceIn(
                  child: Text(
                    "XOX ",
                    style: GoogleFonts.carterOne(
                      fontSize: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
                BounceIn(
                  // Animation effect
                  child: Text(
                    " Game",
                    style: GoogleFonts.carterOne(
                      fontSize: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(seconds: 3),
              curve: Curves.easeInOut,
              height: 5,
              width: _continerWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
