import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class LikeCounter extends StatefulWidget {
  const LikeCounter({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LikeCounterState createState() => _LikeCounterState();
}

class _LikeCounterState extends State<LikeCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${widget.title}',
              style: const TextStyle(fontSize: 100),
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(fontSize: 100),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  // TODO: support pop on any specified stack, not just the current stack
                  // context.navi.stack(CommentStackMarker()).pop();
                },
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => count++),
                child: const Text('+'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.navi.stack(CommentStackMarker()).state++;
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
