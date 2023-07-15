import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> pickPgnFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pgn'],
    );

    if(result != null) {
      File file = File(result.files.single.path!);
      var uri = Uri.parse('http://127.0.0.1:5000/upload_pgn');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('pgnFile', file.path, contentType: MediaType('application', 'x-chess-pgn')));

      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully.');

        response.stream.transform(utf8.decoder).listen((value) {
          // print('Received value: $value');
          try {
            String responseData = jsonDecode(value);
            print(responseData);
            // ChessMatch chessMatch = ChessMatch.fromJson(responseData);
            // print(chessMatch);
          } catch (e) {
            print('Failed to decode JSON: $e');
          }
        });

      } else {
        print('File upload failed.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: pickPgnFile,
          child: Text('Import PGN'),
        ),
      ),
    );
  }
}

class ChessMatch {
  final String event;
  final String site;
  final String date;
  final int round;
  final String white;
  final String black;
  final String result;
  final int blackElo;
  final List<Move> bookMoves;
  final String eco;
  final String opening;
  final String variation;
  final int whiteElo;
  final List<Move> moves;
  final String pgn;

  ChessMatch(this.event, this.site, this.date, this.round, this.white, this.black, this.result, this.blackElo, this.bookMoves, this.eco, this.opening, this.variation, this.whiteElo, this.moves, this.pgn);

  factory ChessMatch.fromJson(Map<String, dynamic> json) {
    return ChessMatch(
        json['Event'],
        json['Site'],
        json['Date'],
        json['Round'],
        json['White'],
        json['Black'],
        json['Result'],
        json['BlackElo'],
        (json['BookMoves'] as List).map((i) => Move.fromJson(i)).toList(),
        json['ECO'],
        json['Opening'],
        json['Variation'],
        json['WhiteElo'],
        (json['moves'] as List).map((i) => Move.fromJson(i)).toList(),
        json['pgn']
    );
  }
}

class Move {
  final int moveNumber;
  final String whiteMoveFrom;
  final String whiteMoveTo;
  final String blackMoveFrom;
  final String blackMoveTo;

  Move(this.moveNumber, this.whiteMoveFrom, this.whiteMoveTo, this.blackMoveFrom, this.blackMoveTo);

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
        json['move_number'],
        json['white_move_from'],
        json['white_move_to'],
        json['black_move_from'],
        json['black_move_to']
    );
  }
}
