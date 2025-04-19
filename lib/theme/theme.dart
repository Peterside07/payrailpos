import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payrailpos/theme/colors.dart';

final ThemeData darkTheme = ThemeData(
  fontFamily: 'TitilliumWeb',
  primarySwatch: Colors.yellow,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.DARK_BG_COLOR,
  primaryColor: AppColors.PRIMARY_COLOR,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    elevation: 0.0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.DARK_BG_COLOR,
  ),
);

final ThemeData lightTheme = ThemeData(
  fontFamily: 'TitilliumWeb',
  primarySwatch: Colors.yellow,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: AppColors.PRIMARY_COLOR,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    iconTheme: IconThemeData(color: AppColors.BAR_ITEM_COLOR),
    titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      color: AppColors.TEXT_COLOR,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
);
