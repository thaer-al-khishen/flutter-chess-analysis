import 'package:flutter/material.dart';

class MovePair extends StatelessWidget {
  final String move1;
  final String move2;
  final VoidCallback onPressedMove1;
  final VoidCallback onPressedMove2;

  MovePair({
    required this.move1,
    this.move2 = "",
    required this.onPressedMove1,
    required this.onPressedMove2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onPressedMove1,
          child: Text(move1),
        ),
        SizedBox(width: 10),
        if (move2.isNotEmpty)
          TextButton(
            onPressed: onPressedMove2,
            child: Text(move2),
          ),
      ],
    );
  }
}
