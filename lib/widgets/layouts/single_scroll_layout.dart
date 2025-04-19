import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/global/constants.dart';

class SingleScrollLayout extends StatelessWidget {
  final double padding;
  final Widget child1;
  final Widget child2;
  final double constraintHeight;

  const SingleScrollLayout({
    Key? key,
    this.padding = kPADDING,
    required this.child1,
    required this.child2,
    this.constraintHeight = 170,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: Get.height - constraintHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [child1, child2],
        ),
      ),
    );
  }
}
