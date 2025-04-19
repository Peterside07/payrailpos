import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDivider extends StatelessWidget {
  final double? height;

  AppDivider({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: Get.isDarkMode ? Colors.white54 : Colors.grey.shade400,
    );
  }
}
