import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({required this.categoryId});

  final int categoryId;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category ${widget.categoryId}'),
      ),
      // TODO: add buttons to navigate to a category page or a product
      body: Text('Category ${widget.categoryId}'),
    );
  }
}
