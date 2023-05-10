import 'package:flutter/material.dart';
import 'package:tiffin/util/images.dart';
import 'package:flutter/material.dart';
import 'package:tiffin/util/images.dart';
import 'package:http/http.dart' as http;
import 'package:tiffin/util/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:tiffin/util/images.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiffin/util/app_constants.dart';

import 'dart:convert';

import 'package:tiffin/viewtiffins/tiffindescription.dart';

class TiffinImage {
  final int id;
  final String image;
  final String name;
  final int price;
  final int userId;

  TiffinImage({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.userId,
  });

  factory TiffinImage.fromJson(Map<String, dynamic> json) {
    return TiffinImage(
      id: json['id'],
      image: json['image'],
      name: json['name'],
    price: int.parse(json['price']), // Parse the 'price' field as an int
      userId: int.parse(json['user_id']),
    );
  }
}

class TiffinImagesList {
  final List<TiffinImage> bannerImages;

  TiffinImagesList({
    required this.bannerImages,
  });

  factory TiffinImagesList.fromJson(List<dynamic> json) {
    List<TiffinImage> bannerImages = [];
    bannerImages = json.map((i) => TiffinImage.fromJson(i)).toList();
    return TiffinImagesList(bannerImages: bannerImages);
  }
}

class Tiffins extends StatefulWidget {
  final String searchQuery;

  const Tiffins({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _TiffinsState createState() => _TiffinsState();
}

class _TiffinsState extends State<Tiffins> {
  late Future<TiffinImagesList> futureBannerImages;

  @override
  void initState() {
    super.initState();
    futureBannerImages = fetchBannerImages();
  }

  Future<TiffinImagesList> fetchBannerImages() async {
    final response = await http.get(Uri.parse(Constants.tiffinrecipes));

    if (response.statusCode == 200) {
      return TiffinImagesList.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load banner images');
    }
  }

  void navigateToChatScreen(int userIdd) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TiffinDescription(
          userId: userIdd,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TiffinImagesList>(
        future: futureBannerImages,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TiffinImage> filteredTiffins = snapshot.data!.bannerImages
                .where((tiffin) => tiffin.name
                    .toLowerCase()
                    .contains(widget.searchQuery.toLowerCase()))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.count(
                childAspectRatio: 0.88,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  for (int i = 0; i < filteredTiffins.length; i++)
                    GestureDetector(
                      onTap: () {
                        navigateToChatScreen(filteredTiffins[i].userId);
                      },
                      child: SizedBox(
                        height: 250, // Fixed height value
                        child: Container(
                          padding: EdgeInsets.only(left: 0, right: 0, top: 10),
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Set mainAxisSize to MainAxisSize.min
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  Constants.BASE_URL_without_API +
                                      'public/tiffinrecipes/' +
                                      filteredTiffins[i].image,
                                  height: 100,
                                  width: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                filteredTiffins[i].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              // SizedBox(height: 5),
                              // Text(
                              //   filteredTiffins[i].name,
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.grey,
                              //     fontSize: 14,
                              //   ),
                              // ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Icon(Icons.timer, color: Colors.grey),
                                  // SizedBox(width: 5),
                                  // Text(
                                  //   filteredTiffins[i].price,
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Colors.grey,
                                  //     fontSize: 14,
                                  //   ),
                                  // ),
                                  // SizedBox(width: 10),
                                  // Icon(Icons.local_fire_department, color: Colors.grey),
                                  // SizedBox(width: 5),
                                  Text(
                                    "\$${filteredTiffins[i].price}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
