import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/theme/colors.dart';

class IssueLogContainer extends StatelessWidget {
  final Widget child;
  final Color? color;

  IssueLogContainer({Key? key, required this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color != null
            ? color
            : Get.isDarkMode
                ? AppColors.DARK_BG_COLOR_2
                : Colors.grey.shade100,
      ),
      child: child,
    );
  }
}
