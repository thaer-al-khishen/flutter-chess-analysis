import 'dart:io';
import 'package:chess/chess.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

List<String> parsePgnFile(FilePickerResult? result) {
  List<String> sanMovesHistory = [];

  if (result != null) {
    PlatformFile file = result.files.first;

    if (file.path != null) {
      File pgnFile = File(file.path!);
      List<int> data = pgnFile.readAsBytesSync();

      // Convert bytes to string and parse PGN
      String pgnData = String.fromCharCodes(data);

      Chess game = Chess();
      game.load_pgn(pgnData);

      // get and print history of moves
      List<State> movesHistory = game.history;
      sanMovesHistory =
          movesHistory.map((state) => state.turn == Color.WHITE ? "${state.move.piece.toUpperCase()}${state.move.toAlgebraic}" : "${state.move.piece}${state.move.toAlgebraic}").toList();
      print(sanMovesHistory);
    }
  }

  return sanMovesHistory;
}

class ChessMove {
  final String piece;
  final String from;
  final String to;

  ChessMove({
    required this.piece,
    required this.from,
    required this.to,
  });

  @override
  String toString() {
    return 'ChessMove: piece=$piece, from=$from, to=$to';
  }

}

List<ChessMove> parsePgnFileWithChessMoveObject(FilePickerResult? result) {
  List<ChessMove> movesHistory = [];

  if (result != null) {
    PlatformFile file = result.files.first;

    if (file.path != null) {
      File pgnFile = File(file.path!);
      List<int> data = pgnFile.readAsBytesSync();

      // Convert bytes to string and parse PGN
      String pgnData = String.fromCharCodes(data);

      Chess game = Chess();
      game.load_pgn(pgnData);

      // get and print history of moves
      List<State> statesHistory = game.history;
      movesHistory = statesHistory.map((state) => ChessMove(
        piece: state.turn == Color.WHITE ? state.move.piece.toUpperCase().toString() : state.move.piece.toString(),
        from: state.move.fromAlgebraic,
        to: state.move.toAlgebraic,
      )).toList();
    }
  }

  return movesHistory;
}

Map<String, dynamic> extractPgnFileDataFromString(String pgnData) {
  List<String> sanMovesHistory = [];
  Map<String, String> headers = {};

  // Split pgnData by lines
  List<String> lines = pgnData.split('\n');

  // Parse headers
  RegExp headerPattern = RegExp(r'\[(\w+) "(.+)"\]');
  bool headerParsing = true;
  for (String line in lines) {
    if (headerParsing) {
      if (headerPattern.hasMatch(line)) {
        Match match = headerPattern.firstMatch(line)!;
        headers[match.group(1)!] = match.group(2)!;
      } else {
        // Stop parsing headers once we reach the moves
        headerParsing = false;
      }
    }

    // Start parsing moves once headers are done
    if (!headerParsing) {
      // Remove result codes
      line = line.replaceAll(RegExp(r'(1-0|0-1|1/2-1/2|\*)'), '');

      // Split line into chunks by move number
      List<String> chunks = line.split(RegExp(r'\d+\.'));

      for (String chunk in chunks) {
        // Remove leading/trailing spaces and split by space to get individual moves
        List<String> moves = chunk.trim().split(' ');

        // Only add to history if there are moves (chunk was not empty or all spaces)
        if (moves.length > 0 && moves[0] != '') {
          sanMovesHistory.add(moves.join(' '));
        }
      }
    }
  }

  return {
    'headers': headers,
    'moves': sanMovesHistory,
  };
}

List<ChessMove> parsePgnDataWithChessMoveObject(String pgnData) {
  List<ChessMove> movesHistory = [];

  Chess game = Chess();
  game.load_pgn(pgnData);

  // get and print history of moves
  List<State> statesHistory = game.history;
  movesHistory = statesHistory.map((state) => ChessMove(
    piece: state.turn == Color.WHITE ? state.move.piece.toUpperCase().toString() : state.move.piece.toString(),
    from: state.move.fromAlgebraic,
    to: state.move.toAlgebraic,
  )).toList();

  return movesHistory;
}

