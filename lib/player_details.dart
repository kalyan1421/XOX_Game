// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xoxgame/game.dart';

class Player {
  String name;
  int wins;

  Player(this.name, this.wins);
}

class Player_details extends StatefulWidget {
  const Player_details({super.key});

  @override
  _Player_detailsState createState() => _Player_detailsState();
}

class _Player_detailsState extends State<Player_details> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _containerWidth = 0; // Initial width

  @override
  void initState() {
    super.initState();

    _startContinuousAnimation();
  }

  void _startContinuousAnimation() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _containerWidth = _containerWidth == 0 ? 250 : 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey, // Add the form key
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("XOX",
                            style: GoogleFonts.carterOne(
                                fontSize: 40, color: Colors.black)),
                        Text(
                          " Game",
                          style: GoogleFonts.carterOne(
                              fontSize: 40, color: Colors.black),
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 3),
                      curve: Curves.bounceInOut,
                      height: 5,
                      width: _containerWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  "Player X ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alegreyaSansSc(fontSize: 26),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 218, 212, 212)
                          .withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: player1Controller,
                    decoration: const InputDecoration(
                      hintText: "Player 1 Name",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Player O ",
                  style: GoogleFonts.alegreyaSansSc(fontSize: 26),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 218, 212, 212)
                          .withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: player2Controller,
                    decoration: const InputDecoration(
                      hintText: "Player 2 Name",
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 35),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicTacToeGame(
                          player1Name: player1Controller.text,
                          player2Name: player2Controller.text,
                        ),
                      ),
                    );
                  }
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade200),
                    child: Text(
                      "Start Game",
                      style: GoogleFonts.alegreyaSansSc(
                          fontSize: 22,
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    player1Controller.clear();
                    player2Controller.clear();
                  },
                  child: const Text(
                    'Reset Game',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
