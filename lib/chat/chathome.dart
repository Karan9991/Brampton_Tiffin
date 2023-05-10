import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:tiffin/addkitchen/createkitchen.dart';
import 'package:tiffin/addkitchen/createtiffin.dart';
import 'package:tiffin/chat/chat.dart';
import 'package:tiffin/chat/chatlist.dart';
import 'package:tiffin/chat/users_or_sellers.dart';
import 'package:tiffin/viewtiffins/viewtiffins.dart';
import 'package:tiffin/chat/chat.dart';
import 'package:tiffin/util/shared_pref.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  String _userType = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final Map<String, dynamic> user = await getUser();
    // userType = user['userType'];

    _getUserType();
  }

  Future<void> _getUserType() async {
    final Map<String, dynamic> user = await getUser();
    setState(() {
      _userType = user['userType'];
    });
  }

  static Future<Map<String, dynamic>> getUser() async {
    await SharedPrefHelper.init();
    return {
      'id': SharedPrefHelper.getInt('id') ?? 0,
      'userType': SharedPrefHelper.getString('userType') ?? '',
      'token': SharedPrefHelper.getString('token') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Chat with ${_userType == 'Customer' ? 'Seller' : 'Customer'}s',
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          // Text(
          //   'Chat with ' + _userType + 's',
          //   style: TextStyle(
          //     color: Colors.white,
          //   ),
          // ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: TabBar(
                indicator: BubbleTabIndicator(
                  indicatorRadius: 10,
                  indicatorHeight: 40,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                      text:
                          '${_userType == 'Customer' ? 'Seller' : 'Customer'}s'),
                  Tab(text: 'Chat List'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            CustomerListScreen(),
            ChatListScreen(),
          ],
        ),
      ),
    );
  }
}
