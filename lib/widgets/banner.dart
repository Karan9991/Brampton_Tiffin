import 'package:flutter/material.dart';
import 'package:tiffin/util/images.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiffin/util/app_constants.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

class BannerImage {
  final int id;
  final String image;

  BannerImage({
    required this.id,
    required this.image,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) {
    return BannerImage(
      id: json['id'],
      image: json['image'],
    );
  }
}

class BannerImagesList {
  final List<BannerImage> bannerImages;

  BannerImagesList({
    required this.bannerImages,
  });

  factory BannerImagesList.fromJson(List<dynamic> json) {
    List<BannerImage> bannerImages = [];
    bannerImages = json.map((i) => BannerImage.fromJson(i)).toList();
    return BannerImagesList(bannerImages: bannerImages);
  }
}

class Banners extends StatefulWidget {
  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  late Future<BannerImagesList> futureBannerImages;

  @override
  void initState() {
    super.initState();
    futureBannerImages = fetchBannerImages();
  }

  Future<BannerImagesList> fetchBannerImages() async {
    final response = await http.get(Uri.parse(Constants.banners));

    if (response.statusCode == 200) {
      return BannerImagesList.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load banner images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerImagesList>(
        future: futureBannerImages,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              height: 200,
              child: CarouselSlider.builder(
                itemCount: snapshot.data!.bannerImages.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(Constants.BASE_URL_without_API +
                            'public/banners/' +
                            snapshot.data!.bannerImages[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                  // Image.network(
                  //   Constants.BASE_URL_without_API +
                  //       'storage/banners/' +
                  //       snapshot.data!.bannerImages[index].image,
                  //   fit: BoxFit.cover,
                  // );
                },
                options: CarouselOptions(
                  height: 180.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        });
  }
}
