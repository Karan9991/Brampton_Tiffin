import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tiffin/util/app_constants.dart';
import 'package:tiffin/util/shared_pref.dart';
import 'package:tiffin/models/tiffin.dart';

class TiffinScreen extends StatefulWidget {
  @override
  _TiffinScreenState createState() => _TiffinScreenState();
}

class _TiffinScreenState extends State<TiffinScreen> {
  late List<Tiffin> _tiffins = [];
  bool _isLoading = true;
  bool _kitchenDeleted = false;
  int userId = 0;

  String kitchenName = '';
  String kitchenImage = '';
  int kitchenId = 0;

  Future<Map<String, dynamic>> fetchKitchenData(int userId) async {
    final String url = Constants.getkitchen;
    final Map<String, dynamic> queryParameters = {
      'user_id': userId,
    };

    final Response response = await Dio().get(
      url,
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      return response.data;
    } else {
      setState(() {
        _isLoading = false;
      });
      _isLoading = false;

      throw Exception('Failed to fetch kitchen data');
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    // _getUserId();
    // print('ral testing ${userId}');
    // _getTiffins(userId);

    _getData();
  }

  Future<void> _getData() async {
    await _getUserId();
    _getTiffins(userId);
  }

  Future<void> _deleteTiffin(int tiffinId) async {
    try {
      final response = await Dio().delete(
        Constants.deletetiffin + "/$tiffinId",
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );
      if (response.data['success'] == true) {
        setState(() {
          _tiffins.removeWhere((tiffin) => tiffin.id == tiffinId);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getTiffins(int userId) async {
    print('get tiffin User ID okkk: $userId');
    try {
      final response = await Dio().get(
        Constants.gettiffins,
        queryParameters: {'user_id': userId},
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );
      final data = response.data['data'] as List<dynamic>;
      _tiffins = data.map((tiffinData) => Tiffin.fromJson(tiffinData)).toList();
//
      final Map<String, dynamic> kitchenData = await fetchKitchenData(userId);
      final bool success = kitchenData['success'];
      final Map<String, dynamic> kitchendata = kitchenData['data'][0];

      if (success) {
        kitchenId = kitchendata['id'];
        kitchenName = kitchendata['name'];
        kitchenImage = kitchendata['image'];
        print("real data" + kitchenName);

        // Do something with the kitchen data...
      } else {
        // Handle the case where the request was not successful...
      }

//
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;

      print(e.toString());
    }
  }

  Future<void> deleteKitchen(int kitchenId) async {
    try {
      final response = await Dio().delete(
        Constants.deletekitchen + "/$kitchenId",
      );
      if (response.data['success'] == true) {
        setState(() {
          _kitchenDeleted = true;
          kitchenName = '';
          kitchenImage = '';
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getUserId() async {
    final Map<String, dynamic> user = await getUser();
    setState(() {
      userId = user['id'];
      print('User ID okkk: $userId');
    });
  }

  static Future<Map<String, dynamic>> getUser() async {
    await SharedPrefHelper.init();
    return {
      'id': SharedPrefHelper.getInt('id') ?? 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _kitchenDeleted
          ? null
          : kitchenName.isNotEmpty
              ? AppBar(
                  title: Text(
                    kitchenName,
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () => {deleteKitchen(kitchenId)},
                    ),
                  ],
                )
              : null,
      body: Column(children: [
        kitchenName.isNotEmpty
            ? Container(
                height: 150.0,
                decoration: BoxDecoration(
                  image: kitchenImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(Constants.BASE_URL_without_API +
                              'public/kitchens/' +
                              kitchenImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container(),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _tiffins.length,
                  itemBuilder: (context, index) {
                    final tiffin = _tiffins[index];
                    return Dismissible(
                      key: Key(tiffin.id.toString()),
                      onDismissed: (direction) async {
                        // Delete tiffin here
                        setState(() {
                          _tiffins.removeAt(index);
                        });
                      },
                      background: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      Constants.BASE_URL_without_API +
                                          'public/tiffinrecipes/' +
                                          tiffin.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.0),
                                  Text(
                                    tiffin.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${tiffin.price}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            _deleteTiffin(tiffin.id),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    tiffin.description,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}

class Tiffin {
  int id;
  String name;
  String description;
  String image;
  String price;

  Tiffin(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.price});

  factory Tiffin.fromJson(Map<String, dynamic> json) {
    return Tiffin(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0.0,
    );
  }
}
