import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tiffin/CategoryDisplay.dart';
import 'package:tiffin/TiffinRecipeDisplay.dart';
import 'package:tiffin/bannerdisplay.dart';
import 'package:tiffin/login.dart';
import 'package:tiffin/util/app_constants.dart';
import 'util/snackbar.dart';
import 'util/images.dart';
import 'dart:convert';
import 'util/dimensions.dart';
import 'util/responsive_helper.dart';
import 'custom_text_field.dart';
import 'util/styles.dart';
import 'package:get/get.dart';
import 'custom_button.dart';
import 'guest_button.dart';
import 'bottom_nav_item.dart';
import 'cart_widget.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'menu_screen.dart';


import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  List<Widget>? _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  //bool _isLogin;

  @override
  void initState() {
    super.initState();

    // _isLogin = Get.find<AuthController>().isLoggedIn();

    // if(_isLogin){
    //   Get.find<OrderController>().getRunningOrders(1, notify: false);
    // }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
     //  HomeScreen(),
      // FavouriteScreen(),
      // CartScreen(fromNav: true),
      // OrderScreen(),
     // Container(),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body: Container(
        child: Column(
          children: [
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: 'Search',
            //       icon: Icon(Icons.search),
            //       border: InputBorder.none,
            //     ),
            //   ),
            // ),
            // BannerDisplay(),
            // CategoryDisplay(),
            // TiffinRecipeDisplay(),
            // Banner display
            // Category display
            // Recipe display
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: _pageIndex == 2
            ? Theme.of(context).primaryColor
            : Theme.of(context).cardColor,
        onPressed: () => _setPage(2),
        child: CartWidget(
            color: _pageIndex == 2
                ? Theme.of(context).cardColor
                : Theme.of(context).disabledColor,
            size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // }

      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Row(children: [
            BottomNavItem(
                iconData: Icons.home,
                isSelected: _pageIndex == 0,
                onTap: () => _setPage(0)
                ),
            BottomNavItem(
                iconData: Icons.notifications,
                isSelected: _pageIndex == 1,
                onTap: () => _setPage(1)),
            Expanded(child: SizedBox()),
            BottomNavItem(
                iconData: Icons.chat,
                isSelected: _pageIndex == 3,
                onTap: () => _setPage(3)),
            BottomNavItem(
                iconData: Icons.menu,
                isSelected: _pageIndex == 4,
                onTap: () {
                  Get.bottomSheet(MenuScreen(),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true);
                }),
          ]),
        ),
      ),
     
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      // _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}

