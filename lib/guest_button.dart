import 'package:tiffin/home_screens/home.dart';

import 'util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(400, 50),
        backgroundColor: Colors.green, // set background color
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        Navigator.pushReplacementNamed(context, '/');
      },
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: '${'Continue as'.tr} ',
            style: robotoRegular.copyWith(
                color: Colors.white)), // set text color to white
        TextSpan(
            text: 'Guest'.tr,
            style: robotoMedium.copyWith(
                color: Colors.white)), // set text color to white
      ])),
    );
  }
}
