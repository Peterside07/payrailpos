import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/service/storage.dart';

import 'package:payrailpos/translations/en.dart';
import 'package:payrailpos/translations/hau.dart';
import 'package:payrailpos/translations/ibo.dart';
import 'package:payrailpos/translations/yor.dart';

class AppMessages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': ENGLISH_TRANSLATION,
        'yor': YORUBA_TRANSLATION,
        'hau': HAUSA_TRANSLATION,
        'ibo': IBO_TRANSLATION,
      };
}

const EN_LOCALE = Locale('en');
const YOR_LOCALE = Locale('yor');
const HAU_LOCALE = Locale('hau');
const IBO_LOCALE = Locale('ibo');

void updateLocale(String lang) {
  switch (lang.toLowerCase()) {
    case 'yor':
      Get.updateLocale(YOR_LOCALE);
      break;
    case 'hau':
      Get.updateLocale(HAU_LOCALE);
      break;
    case 'ibo':
      Get.updateLocale(IBO_LOCALE);
      break;
    default:
      Get.updateLocale(EN_LOCALE);
  }
  StorageService().saveAppLanguage(lang);
}
