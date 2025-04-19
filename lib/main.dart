import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/global_controller.dart';
import 'package:payrailpos/login.dart';
import 'package:payrailpos/theme/theme.dart';
import 'package:payrailpos/translations/translations.dart';
import 'package:payrailpos/withdraw.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final globalController = Get.put(GlobalController());

  @override
  void initState() {
    //_appTimeout();
    super.initState();
  }

  void _appTimeout() async {
    // _timer?.cancel();

    // _timer = Timer(Duration(minutes: 50), () async {
    //   var token = TokenService.token;

    //   if (Get.currentRoute != '/Signin' && token.isNotEmpty) {
    //     await StorageService().removeToken();
    //     Get.offAll(() => Signin());
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanDown: (e) => _appTimeout(),
      onPanStart: (e) => _appTimeout(),
      onPanEnd: (e) => _appTimeout(),
      onTap: () => _appTimeout(),
      child: Obx(
        () => GetMaterialApp(
          translations: AppMessages(),
          locale: EN_LOCALE,
            fallbackLocale: EN_LOCALE,
          title: 'Payrail POS',
                      darkTheme: darkTheme,
            theme: lightTheme,
            themeMode: globalController.currentTheme.value == 'Light'
                ? ThemeMode.light
                : globalController.currentTheme.value == 'Dark'
                    ? ThemeMode.dark
                    : ThemeMode.system,
          home: Signin(),
        ),
      ),
    );
  }
}
