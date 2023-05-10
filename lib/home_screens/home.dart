import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tiffin/auth/signin.dart';
import 'package:tiffin/bannerdisplay.dart';
import 'package:tiffin/chat/chatlist.dart';
import 'package:tiffin/home_screens/HomeAppBar.dart';
import 'package:tiffin/util/app_constants.dart';
import 'package:tiffin/widgets/categories.dart';
import 'package:tiffin/widgets/banner.dart';
import 'package:tiffin/widgets/tiffinwidgets.dart';
import 'package:tiffin/addkitchen/add.dart';
import 'package:tiffin/util/shared_pref.dart';
import 'package:tiffin/chat/chathome.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String usertoken = '';
  String userType = '';
  String email = '';
  String _searchQuery = '';

  List<Widget>? _screens;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  checkLoginStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Map<String, dynamic> user = await getUser();
      final String usertoken = user['token'];
      final String email = user['email'];
      final String userType = user['userType'];

      setState(() {
        this.usertoken = usertoken;
        this.userType = userType;
        this.email = email;

        _screens = [
          MyHomePage(),
          userType == 'Customer' ? ChatHome() : MyTabBarScreen(),
          ChatHome(),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (usertoken == null || usertoken.isEmpty) {
      print('aaaaaa $usertoken');
      // Redirect to the login page if the user is not logged in
      return SignIn();
    } else {
      print('bbbbb $usertoken');

      return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: null,
                accountEmail: Text(
                  email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              //       ListTile(
              //   leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
              //   title: Text('Profile'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Navigate to profile page
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.info,color: Theme.of(context).primaryColor),
              //   title: Text('About Us'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Navigate to about us page
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.privacy_tip,color: Theme.of(context).primaryColor),
              //   title: Text('Privacy Policy'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Navigate to privacy policy page
              //   },
              // ),
              ListTile(
                leading:
                    Icon(Icons.logout, color: Theme.of(context).primaryColor),
                title: Text('Logout'),
                onTap: () {
                  logout();
                  Navigator.pop(context);
                  // Perform logout action
                },
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            HomeAppBar(),
            Container(
              // height: 500,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  )),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          height: 50,
                          width: 250,
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search here..."),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.search,
                          size: 27,
                        )
                      ],
                    ),
                  ),
                  //banner

                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    //Banners
                    child: Banners(),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: Text(
                      "Best Selling",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),

                  //Categories
                  Categories(),
                  //Tiffins
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text(
                      "Tiffins",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),

                  //tiffins
                  //Flexible(
                  Tiffins(searchQuery: _searchQuery),
                  //),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _screens![index]),
            );
          },
          color: Theme.of(context).primaryColor,
          height: 50,
          items: [
            Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            if (userType == 'Customer')
              SizedBox.shrink()
            else
              Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            Icon(
              Icons.chat,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
  }

  Future<void> logout() async {
    final Map<String, dynamic> user = await getUser();
    final String usertoken = user['token'];

    print('user logout $usertoken');

    final url = Uri.parse(Constants.logout);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $usertoken',
    };
    final response = await http.post(
      url,
      headers: headers,
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      await SharedPrefHelper.init();
      await SharedPrefHelper.clear();

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      // Handle success response
    } else {
      // Handle error response
    }
  }

  static Future<Map<String, dynamic>> getUser() async {
    await SharedPrefHelper.init();
    return {
      'email': SharedPrefHelper.getString('email') ?? '',
      'userType': SharedPrefHelper.getString('userType') ?? '',
      'token': SharedPrefHelper.getString('token') ?? '',
    };
  }

  Future<void> checkLoginStatus() async {
    final Map<String, dynamic> user = await getUser();
    setState(() {
      usertoken = user['token'];
    });
  }
}
