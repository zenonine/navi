import 'package:flutter/material.dart';

import 'index.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({required this.section, required this.tab});

  final Section section;
  final SectionTab tab;

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
            sectionName(widget.section) + ' / ' + sectionTabName(widget.tab)));
  }
}
