import 'dart:convert';
import 'util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class BannerDisplay extends StatefulWidget {
  @override
  _BannerDisplayState createState() => _BannerDisplayState();
}

class _BannerDisplayState extends State<BannerDisplay> {
  List<String> _banners = [];

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    var response = await http.get(Uri.parse(Constants.banners));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      var bannerUrls = <String>[];
      for (var banner in data) {
        bannerUrls.add(Constants.BASE_URL_without_API+'public/banners/' + banner['image']);
      }
      setState(() {
        _banners = bannerUrls;
      });
    } else {
      throw Exception('Failed to fetch banners');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _banners.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Image.network(_banners[index]),
          );
        },
      ),
    );
  }
}

