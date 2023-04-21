import 'package:flutter/material.dart';

import 'board_tile.dart';
import 'tile_state.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9, TileState.EMPTY);
  var _currentTurn = TileState.CROSS;
  var _crossScore = 0;
  var _circleScore = 0;
  var _isPlayerTurn = true;
  String? p1;
  String? p2;

  @override
  void didChangeDependencies() {
    var agrs = ModalRoute.of(context)?.settings.arguments as Map;
    p1 = agrs['p1'];
    p2 = agrs['p2'];
    // log(agrs.toString());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreCard(TileState.CROSS),
                _buildScoreCard(TileState.CIRCLE),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/board.png',
                  ),
                  _boardTiles(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _resetScreen,
                child: Text(
                  'Reset Game',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(TileState tileState) {
    var score = tileState == TileState.CROSS ? _crossScore : _circleScore;
    var name = tileState == TileState.CROSS ? p1 : p2;

    return Card(
      elevation: 5,
      color: _isPlayerTurn && _currentTurn == tileState ? Colors.grey.shade200 : Colors.white,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(
              tileState == TileState.CROSS ? 'assets/images/x.png' : 'assets/images/o.png',
              width: 60,
              height: 60,
            ),
            SizedBox(height: 10),
            Text(
              '$name : $score',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tilesDimension = boardDimension / 3;
      return Container(
        width: boardDimension,
        height: boardDimension,
        child: Column(
          children: chunk(_boardState, 3).asMap().entries.map(
            (entry) {
              final chunkIndex = entry.key;
              final titleStateChunk = entry.value;
              return Row(
                children: titleStateChunk.asMap().entries.map(
                  (innerEntry) {
                    final innerIndex = innerEntry.key;
                    final tileState = innerEntry.value;
                    final tileIndex = (chunkIndex * 3) + innerIndex;

                    return BoardTile(
                      dimension: tilesDimension,
                      onPressed: () => _updateTileStateForIndex(tileIndex),
                      tileState: tileState,
                    );
                  },
                ).toList(),
              );
            },
          ).toList(),
        ),
      );
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      _boardState[selectedIndex] = _currentTurn;
      _currentTurn = _currentTurn == TileState.CROSS ? TileState.CIRCLE : TileState.CROSS;
      setState(() {});

      final winner = _findWinner();
      if (winner != null) {
        _resetBoard();
        _showWinnerDialog(winner);
      } else if (!_boardState.contains(TileState.EMPTY)) {
        _resetBoard();
        _showDrawDialog();
      }
    }
  }

  TileState? _findWinner() {
    TileState? Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) && (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };
    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState? winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i];
        break;
      }
    }
    return winner;
  }

  void _resetBoard() {
    _boardState = List.filled(9, TileState.EMPTY);
    _currentTurn = TileState.CROSS;
  }

  void _showWinnerDialog(TileState winner) {
    var name = winner == TileState.CROSS ? p1 : p2;
    final title = winner == TileState.CROSS ? '$name Wins!' : '$name Wins!';
    final message = 'Do you want to play again?';
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                _incrementScore(winner);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    final message = 'It\'s a draw! Do you want to play again?';
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (context) {
        return AlertDialog(
          title: Text('Draw!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _incrementScore(TileState winner) {
    if (winner == TileState.CROSS) {
      setState(() {
        _crossScore++;
      });
    } else if (winner == TileState.CIRCLE) {
      setState(() {
        _circleScore++;
      });
    }
  }

  void _resetScreen() {
    _crossScore = 0;
    _circleScore = 0;
    _boardState = List.filled(9, TileState.EMPTY);
    setState(() {});
  }
}
