// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteremv/flutteremv.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/pos_controller.dart';
import 'package:payrailpos/login.dart';
import 'package:payrailpos/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

 String _platformVersion = 'Unknown';
  final _topwisemp35pPlugin = Flutteremv();

  final posCtrl = Get.find<POSController>();

class _SplashScreenState extends State<SplashScreen> {
        Future<void> initPlatformState() async {
    String platformVersion;
       try {
      platformVersion =
          await _topwisemp35pPlugin.deviceserialnumber() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = '';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    posCtrl.deviceSerialNumber.value = _platformVersion;
    print('Platform Version: $_platformVersion');
     navigateToNextPage();
  }
  
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async {
      initPlatformState();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.PRIMARY_COLOR,
      body: Center(
        child: Image(
          image: AssetImage('assets/images/splash.png'),
        ),
      ),
    );
  }

  void navigateToNextPage()async{
      Get.off(() => Signin());
  }
}
