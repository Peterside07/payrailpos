import 'package:flutter/material.dart';


class EmptyWidget extends StatelessWidget {
  final String message;
  final String imageName;
  final double height;
  final VoidCallback? onTap;

  EmptyWidget({
    this.message = 'No Data',
    this.imageName = 'no_data',
    this.height = 150.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Opacity(
          //   opacity: 0.8,
          //   child: SvgPicture.asset(
          //     'assets/images/$imageName.svg',
          //     height: height,
          //     width: double.infinity,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          SizedBox(height: 15),
          Text(
            '$message',
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
          )
        ],
      ),
    );
  }
}
