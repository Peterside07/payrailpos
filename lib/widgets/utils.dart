import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/theme/colors.dart';


class Utils {
  static BoxShadow appBoxShadow() {
    return BoxShadow(
      offset: Offset(0, 3),
      blurRadius: 26,
      color: Get.isDarkMode ? Colors.black : Color.fromRGBO(0, 0, 0, 0.15),
    );
  }

  static AppBar appBar(BuildContext context, {String title = ''}) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  static showAlert(
    String message, {
    String title = '',
    AlertType type = AlertType.ERROR,
  }) {
    AppAlert(message: message, title: title, type: type).showAlert();
  }

  static showSheetOptions(Widget view) {
    Get.bottomSheet(
      view,
      enableDrag: true,
      isScrollControlled: true,
      ignoreSafeArea: false,
      isDismissible: true,
    );
  }

}




enum AlertType { ERROR, SUCCESS, INFO }

class AppAlert extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;


  AppAlert({
    this.title = '',
    required this.message,
    this.type = AlertType.ERROR,
  });

  final textStyle = TextStyle(fontWeight: FontWeight.w700);

  String getTitle() {
    switch (type) {
      case AlertType.INFO:
        return 'info'.tr;
      case AlertType.SUCCESS:
        return 'success'.tr;
      case AlertType.ERROR:
        return 'error'.tr;
    }
  }

  void showAlert() {
    Get.showSnackbar(
      GetBar(
        backgroundColor: type == AlertType.ERROR
            ? Colors.red
            : type == AlertType.INFO
                ? AppColors.PRIMARY_COLOR
                : Colors.green,
        title: title.isEmpty ? getTitle() : title,
        icon: Icon(Icons.error_outline_rounded),
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        onTap: (obj) => Get.back(),
        message: message.isNotEmpty ? message : 'An unexpected error occurred',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(
              title.isEmpty ? 'error'.tr : '$title',
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    AppColors.PRIMARY_COLOR,
                  ),
                ),
                child: Text(
                  'ok'.tr,
                  style: textStyle.copyWith(color: AppColors.PRIMARY_COLOR),
                ),
              )
            ],
          )
        : CupertinoAlertDialog(
            title: Text(title.isEmpty ? 'error'.tr : '$title'),
            content: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                '$message',
              ),
            ),
            actions: [
              CupertinoButton(
                child: Text('ok'.tr, style: textStyle),
                onPressed: () => Get.back(),
              )
            ],
          );
  }
}
