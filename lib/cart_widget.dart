
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'util/styles.dart';

class CartWidget extends StatelessWidget {
  final Color color;
  final double size;
  final bool fromRestaurant;
  CartWidget({required this.color, required this.size, this.fromRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Icon(
        Icons.add, size: size,
        color: color,
      ),
     SizedBox(),
      // }),
    ]);
  }
}
