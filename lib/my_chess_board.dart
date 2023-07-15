import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess/chess.dart' as chess;

class MyChessBoardController {
  final ChessBoardController _controller = ChessBoardController();
  chess.Chess game = chess.Chess();

  void reset() {
    game = chess.Chess();
    _controller.resetBoard();
  }

  void makeMove({required String from, required String to}) {
    game.move({
      'from': from,
      'to': to,
    });

    _controller.makeMove(from: from, to: to);
  }
}

class MyChessBoard extends ChessBoard {
  final MyChessBoardController myController;

  MyChessBoard({
    required this.myController,
    required double size
    // add all other parameters you need
  }) : super(
      controller: myController._controller,
      size: size
    // add all other parameters you need
  );

// You can override other methods and refer to `myController` if needed
}
