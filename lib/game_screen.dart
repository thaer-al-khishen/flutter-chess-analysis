import 'package:flutter/material.dart';
import 'PgnHelpers.dart';
import 'move_pair.dart';
import 'my_chess_board.dart';

class GameScreen extends StatefulWidget {
  final List<ChessMove> movesHistory;
  final List<String> formattedMovesHistory;

  GameScreen({required this.movesHistory, required this.formattedMovesHistory});
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  MyChessBoardController _controller = MyChessBoardController();

  void replayMovesTo(int targetMove) {
    _controller.reset();

    for (int i = 0; i < targetMove && i < widget.movesHistory.length; i++) {
      _controller.makeMove(
        from: widget.movesHistory[i].from,
        to: widget.movesHistory[i].to,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MovePair> movePairs = [];
    for (int i = 0; i < widget.movesHistory.length; i += 2) {
      String move1 = widget.formattedMovesHistory[i];
      String move2 = "";
      if (i + 1 < widget.movesHistory.length) {
        move2 = widget.formattedMovesHistory[i + 1];
      }
      movePairs.add(
        MovePair(
          move1: move1,
          move2: move2,
          onPressedMove1: () => replayMovesTo(i + 1),
          onPressedMove2: () => replayMovesTo(i + 2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Screen'),
      ),
      body: Row(
        children: [
          MyChessBoard(
            size: MediaQuery.of(context).size.width / 3,
            myController: _controller,
            // Other parameters
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: movePairs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
