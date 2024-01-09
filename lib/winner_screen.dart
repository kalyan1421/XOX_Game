import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WinnerScreen extends StatefulWidget {
  final String? overallWinner;

  WinnerScreen(
      {Key? key, required String winnerName, required this.overallWinner})
      : super(key: key);

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(height: 120),
          Image.asset(
            "assets/Winner_image.png",
            scale: 1.8,
          ),
          const SizedBox(height: 5),
          Text(
            "Hii ${widget.overallWinner}",
            style: GoogleFonts.outfit(fontSize: 28),
          ),
          const SizedBox(height: 70),
          Image.asset(
            "assets/star_10273194.png",
            scale: 3,
          ),
          Text(
            "Congartulations!",
            style: GoogleFonts.lobster(fontSize: 36),
          ),
          Text(
            "You have Won the Match ",
            style: GoogleFonts.lobster(fontSize: 20),
          ),
        ],
      ),
    ));
  }
}
