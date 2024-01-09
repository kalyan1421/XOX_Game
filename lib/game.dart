// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoxgame/player_details.dart';
import 'package:xoxgame/winner_screen.dart';

class TicTacToeGame extends StatefulWidget {
  final String player1Name;
  final String player2Name;

  const TicTacToeGame(
      {super.key, required this.player1Name, required this.player2Name});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  Player? player1;
  Player? player2;
  List<List<String>>? board;
  String? currentPlayer;
  bool? gameOver;
  int currentRound = 0;
  final int totalRounds = 5;
  String? overallWinner;

  @override
  void initState() {
    super.initState();
    player1 = Player(widget.player1Name, 0);
    player2 = Player(widget.player2Name, 0);
    initializeGame();
    loadPlayerWins();
    determineOverallWinner();
  }

  void initializeGame() {
    board = List.generate(3, (i) => List<String>.generate(3, (j) => ''));
    currentPlayer = "X";
    gameOver = false;
  }

  void makeMove(int row, int col) {
    if (board![row][col] == '' && !gameOver!) {
      setState(() {
        board![row][col] = currentPlayer!;
        if (checkWin(row, col, currentPlayer!)) {
          gameOver = true;
          updateWinCount(currentPlayer!);
        } else {
          if (board!.every((row) => row.every((cell) => cell != ''))) {
            gameOver = true;
            currentPlayer = "It's a draw!";
          } else {
            currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
          }
        }
      });
    }
  }

  Future<void> loadPlayerWins() async {
    final prefs = await SharedPreferences.getInstance();
    player1?.wins = prefs.getInt('${player1?.name}_wins') ?? 0;
    player2?.wins = prefs.getInt('${player2?.name}_wins') ?? 0;
    setState(() {});
  }

  void updateWinCount(String winner) async {
    setState(() {
      if (winner == 'X') {
        player1!.wins++;
      } else if (winner == 'O') {
        player2!.wins++;
      }

      if (currentRound < totalRounds) {
        currentRound++;
        if (currentRound == totalRounds) {
          determineOverallWinner();
          resetPlayerWins();
        }
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${player1!.name}_wins', player1!.wins);
    await prefs.setInt('${player2!.name}_wins', player2!.wins);
  }

  void resetPlayerWins() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('${player1!.name}_wins');
    prefs.remove('${player2!.name}_wins');

    setState(() {
      player1!.wins = 0;
      player2!.wins = 0;
    });
  }

  bool checkWin(int row, col, String player) {
    if (board![row].every((cell) => cell == player)) {
      return true;
    }

    // Check the column
    if (List.generate(3, (i) => board![i][col])
        .every((cell) => cell == player)) {
      return true;
    }

    // Check the main diagonal
    if (row == col &&
        List.generate(3, (i) => board![i][i]).every((cell) => cell == player)) {
      return true;
    }

    // Check the other diagonal
    if (row + col == 2 &&
        List.generate(3, (i) => board![i][2 - i])
            .every((cell) => cell == player)) {
      return true;
    }

    return false;
  }

  void determineOverallWinner() {
    if (player1!.wins > player2!.wins) {
      setState(() {
        overallWinner = player1!.name;
      });
    } else if (player2!.wins > player1!.wins) {
      setState(() {
        overallWinner = player2!.name;
      });
    } else {
      setState(() {
        overallWinner = "It's a tie!";
      });
    }
    navigateToOverallWinnerScreen();
  }

  void navigateToOverallWinnerScreen() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          currentRound = 0;
          initializeGame();
        });
      }
    });
  }

  void removeSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('${player1?.name}_wins');
    prefs.remove('${player2?.name}_wins');
  }

  @override
  void dispose() {
    removeSavedData();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: currentRound < totalRounds
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 45),
                        Text(
                          "Play With Friends",
                          style: GoogleFonts.alegreyaSansSc(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 160,
                                width: 140,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: Offset(0, 3),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white),
                              ),
                            ),
                            Positioned(
                              left: 40,
                              bottom: 130,
                              child: Container(
                                alignment: Alignment.center,
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        offset: Offset(-1, -1),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        offset: Offset(1, 1),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            "https://play-lh.googleusercontent.com/C9CAt9tZr8SSi4zKCxhQc9v4I6AOTqRmnLchsu1wVDQL0gsQ3fmbCVgQmOVM1zPru8UH=w240-h480-rw")),
                                    color: Colors.indigo,
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    shape: BoxShape.circle),
                              ),
                            ),
                            Positioned(
                              bottom: 75,
                              left: 10,
                              child: Text(
                                player1!.name,
                                // player1!.name,
                                style: GoogleFonts.exo2(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 35,
                              child: Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset(
                                  "assets/X.png",
                                  scale: 8,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black38),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: Main,
                              children: [
                                Text(
                                  "  ${currentRound + 1}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  "Round",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 160,
                                width: 140,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        offset: Offset(0, 3),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white),
                              ),
                            ),
                            Positioned(
                              left: 40,
                              bottom: 130,
                              child: Container(
                                alignment: Alignment.center,
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        offset: Offset(-1, -1),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        offset: Offset(1, 1),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            "https://images.unsplash.com/photo-1497316730643-415fac54a2af?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D")),
                                    color: Colors.indigo,
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    shape: BoxShape.circle),
                              ),
                            ),
                            Positioned(
                              bottom: 75,
                              left: 10,
                              child: Text(
                                player2!.name,
                                // player1!.name,
                                style: GoogleFonts.exo2(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 35,
                              child: Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset(
                                  "assets/O.png",
                                  scale: 8,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 10)
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 25),
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  offset: Offset(0, 1.5),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              "Won Rounds: ${player1!.wins}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 1.5),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              "Won Rounds: ${player2!.wins}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25)
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Text(
                    // 'Wins: ${player1?.name}: ${player1!.wins} | ${player2!.name}: ${player2!.wins}'),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < 3; i++)
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  for (int j = 0; j < 3; j++)
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: GestureDetector(
                                        onTap: () => makeMove(i, j),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade400,
                                                offset: Offset(0, 1.5),
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                              ),
                                              BoxShadow(
                                                color: Colors.grey.shade400,
                                                offset: Offset(-2, -1.5),
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: Colors.black38,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              board![i][j],
                                              style: const TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (gameOver == true)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          currentPlayer == "It's a draw!"
                              ? "It's a draw match!"
                              : 'Player $currentPlayer wins!',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: currentPlayer == "It's a draw!"
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.black), // Background color
                        foregroundColor: MaterialStateProperty.all(
                            Colors.white), // Text color
                        shadowColor: MaterialStateProperty.all(
                            Colors.grey), // Shadow color
                        elevation: MaterialStateProperty.all(
                            4), // Elevation (shadow depth)
                        side: MaterialStateProperty.all(const BorderSide(
                            color: Colors.white, width: 1)), // Border
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Player_details(),
                            ),
                          );
                        });
                      },
                      child: const Text('Reset Game and Go Back'),
                    )
                  ],
                ),
              )
            : WinnerScreen(
                overallWinner: overallWinner,
                winnerName: overallWinner.toString(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
