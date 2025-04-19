import 'dart:io';

import 'package:get/get.dart';
import 'package:payrailpos/model/pos_model.dart';
import 'package:payrailpos/service/storage.dart';
import 'package:payrailpos/translations/translations.dart';



class GlobalController extends GetxController {
  var deviceId = ''.obs;
  var deviceName = ''.obs;
  var deviceType = ''.obs;
  var posDeviceId = ''.obs;
  var posDeviceName = ''.obs;
  var posDeviceType = ''.obs;
  var barIndex = 0.obs;
  var tr = {}.obs;
  var token = ''.obs;
  var periodOfDay = ''.obs;
  var currentTheme = 'System'.obs;
  var appLanguage = 'EN'.obs;
  var appVersion = ''.obs;

  @override
  void onInit() {
    fetchAppTheme();
    super.onInit();
  }

  @override
  void onReady() {
    deviceDetails();
        getStoredAppLanguage();

    super.onReady();
  }


  void getStoredAppLanguage() async {
    var lang = await StorageService().getAppLanguage();
    appLanguage.value = lang;
    updateLocale(lang);
  }



  void onSetTheme(String theme) {
    currentTheme.value = theme;
    StorageService().saveCurrentTheme(theme);
  }

  void fetchAppTheme() async {
    var theme = await StorageService().getCurrentTheme();
    currentTheme.value = theme;
  }

  Future<void> _initPackageInfo() async {
  //  final info = await PackageInfo.fromPlatform();

  }


  void deviceDetails() async {
        //final info = await PackageInfo.fromPlatform();
    
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   posDeviceId.value = androidInfo.androidId;
    //   posDeviceName.value = androidInfo.model;
    //   posDeviceType.value = 'Android';
    // } 

    // PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    //   appVersion.value = packageInfo.version;
    // });
  }


  void setDeviceDetails(PosParameterModel parameters) {
    deviceId.value = parameters.serialNo;
    deviceType.value = 'Android';
    deviceName.value = 'POS';
    appVersion.value = parameters.serialNo;
  }
}
