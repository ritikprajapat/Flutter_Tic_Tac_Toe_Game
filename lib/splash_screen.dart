import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingControllerPlayer1 = TextEditingController();
    TextEditingController textEditingControllerPlayer2 = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.red.shade400,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Tic Tac Toe Game',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: textEditingControllerPlayer1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    hintText: 'Player 1',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: textEditingControllerPlayer2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    hintText: 'Player 2',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(60),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  'Start Game',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    HomeScreen.routeName,
                    arguments: {
                      'p1': textEditingControllerPlayer1.text,
                      'p2': textEditingControllerPlayer2.text,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
