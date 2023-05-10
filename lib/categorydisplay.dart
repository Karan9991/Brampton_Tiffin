import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryDisplay extends StatefulWidget {
  @override
  _CategoryDisplayState createState() => _CategoryDisplayState();
}

class _CategoryDisplayState extends State<CategoryDisplay> {
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    var response = await http.get(Uri.parse('https://your-laravel-backend.com/api/categories'));

    if (response.statusCode == 200) {
      setState(() {
        _categories = List<String>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: _categories
                .map(
                  (category) => Chip(
                    label: Text(category),
                    backgroundColor: Colors.grey[300],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
