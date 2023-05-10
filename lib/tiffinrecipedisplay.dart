import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TiffinRecipeDisplay extends StatefulWidget {
  @override
  _TiffinRecipeDisplayState createState() => _TiffinRecipeDisplayState();
}

class _TiffinRecipeDisplayState extends State<TiffinRecipeDisplay> {
  List<Map<String, dynamic>> _recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    var response = await http.get(Uri.parse('https://your-laravel-backend.com/api/recipes'));

    if (response.statusCode == 200) {
      setState(() {
        _recipes = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to fetch recipes');
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
            'Tiffin Recipes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(
                    _recipes[index]['image_url'],
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    _recipes[index]['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(_recipes[index]['description']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
