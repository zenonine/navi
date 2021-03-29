import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

class LikeCounter extends StatefulWidget {
  const LikeCounter({Key? key, required this.title, this.onNextComment})
      : super(key: key);

  final String title;
  final void Function()? onNextComment;

  @override
  _LikeCounterState createState() => _LikeCounterState();
}

class _LikeCounterState extends State<LikeCounter> {
  int count = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('LikeCounter ${context.stacks}');
  }

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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => count++),
                child: const Text('+'),
              ),
              ElevatedButton(
                onPressed: () => widget.onNextComment?.call(),
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
