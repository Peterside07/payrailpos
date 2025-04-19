import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:payrailpos/theme/colors.dart';

class AppLoader extends StatelessWidget {
  final String message;
  final bool isLoading;
  final Widget child;

  AppLoader({this.message = '', this.isLoading = false, required this.child});

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      child: child,
      isLoading: isLoading,
    //  opacity: 1,
      color: Get.isDarkMode
          ? Color.fromRGBO(0, 0, 0, 0.9)
          : Color.fromRGBO(255, 255, 255, 0.9),
      progressIndicator: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.PRIMARY_COLOR,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    message.isNotEmpty ? '$message' : '${'please_wait'.tr}...',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
