import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffin/addkitchen/add.dart';
import 'package:tiffin/auth/signin.dart';
import 'package:tiffin/home_screens/home.dart';
import 'package:tiffin/onbording.dart';
import 'package:tiffin/util/constants.dart';
import 'package:tiffin/webview.dart';

int? initScreen = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  // SharedPrefHelper.init();
  // initScreen = SharedPrefHelper.getInt('initScreen');
  // SharedPrefHelper.setInt('initScreen', 1);
  print('initScreen ${initScreen}');
  //  await SharedPrefHelper.init();
  //   await SharedPrefHelper.setBool('showOnboardingScreen', true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: lightGren,
      ),
      // home: MyAppWeb(),
    //  home: MyTabBarScreen(),

      home: initScreen == 0 || initScreen == null ? Onbording() : MyHomePage(),
      initialRoute: '/home',
      routes: {
        '/home': (context) =>
            initScreen == 0 || initScreen == null ? Onbording() : MyHomePage(),
        '/login': (context) => SignIn(),
      },
    );
  }
}
