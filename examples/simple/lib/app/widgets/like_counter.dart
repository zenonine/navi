import 'package:flutter/material.dart';

class LikeCounter extends StatefulWidget {
  LikeCounter({Key? key, required this.title, this.onNextComment})
      : super(key: key);

  final String title;
  final void Function()? onNextComment;

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
              style: TextStyle(fontSize: 100),
            ),
          ),
          Text(
            '$count',
            style: TextStyle(fontSize: 100),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Previous'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => count++),
                child: Text('+'),
              ),
              ElevatedButton(
                onPressed: () => widget.onNextComment?.call(),
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
