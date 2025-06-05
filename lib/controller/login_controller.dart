import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/global_controller.dart';
import 'package:payrailpos/controller/pos_controller.dart';
import 'package:payrailpos/global/endpoints.dart';
import 'package:payrailpos/screen/home/home_screen.dart';
import 'package:payrailpos/service/api.dart';
import 'package:payrailpos/service/storage.dart';
import 'package:payrailpos/service/token.dart';
import 'package:payrailpos/widgets/utils.dart';

class LoginController extends GetxController {
  TextEditingController phoneCtx = TextEditingController(text: '');
  TextEditingController pinCtx = TextEditingController(text: '');
  static const platform = MethodChannel('com.example.pos/keypad');

  var isLoading = false.obs;
  var phone = ''.obs;
  var phoneCode = '+234'.obs;
  var password = ''.obs;
  var rememberMe = false.obs;
  var isPhoneFieldFocused = true;

  final posCtrl = Get.find<POSController>(); 
  

  final globalCtx = Get.put(GlobalController());

  void handleKeyPress(KeyEvent event) {
    final logicalKey = event.logicalKey;
    String? key;

    // Map logical keys to digits and actions
    if (logicalKey == LogicalKeyboardKey.digit0) {
      key = '0';
    } else if (logicalKey == LogicalKeyboardKey.digit1) {
      key = '1';
    } else if (logicalKey == LogicalKeyboardKey.digit2) {
      key = '2';
    } else if (logicalKey == LogicalKeyboardKey.digit3) {
      key = '3';
    } else if (logicalKey == LogicalKeyboardKey.digit4) {
      key = '4';
    } else if (logicalKey == LogicalKeyboardKey.digit5) {
      key = '5';
    } else if (logicalKey == LogicalKeyboardKey.digit6) {
      key = '6';
    } else if (logicalKey == LogicalKeyboardKey.digit7) {
      key = '7';
    } else if (logicalKey == LogicalKeyboardKey.digit8) {
      key = '8';
    } else if (logicalKey == LogicalKeyboardKey.digit9) {
      key = '9';
    } else if (logicalKey == LogicalKeyboardKey.backspace) {
      key = 'BACKSPACE';
    } else if (logicalKey == LogicalKeyboardKey.clear) {
      key = 'CLEAR';
    }

    if (key != null) {
      if (isPhoneFieldFocused) {
        _handlePhoneInput(key);
      } else {
        _handlePinInput(key);
      }
    }
  }

  void _handlePhoneInput(String key) {
    if (key == 'BACKSPACE') {
      if (phoneCtx.text.isNotEmpty) {
        phoneCtx.text = phoneCtx.text.substring(0, phoneCtx.text.length - 1);
      }
    } else if (key == 'CLEAR') {
      phoneCtx.clear();
    } else if (RegExp(r'[0-9]').hasMatch(key)) {
      if (phoneCtx.text.length < 10) {
        // Limit phone to 10 digits
        phoneCtx.text += key;
      }
    }
    phone.value = phoneCtx.text;
  }

  void _handlePinInput(String key) {
    if (key == 'BACKSPACE') {
      if (pinCtx.text.isNotEmpty) {
        pinCtx.text = pinCtx.text.substring(0, pinCtx.text.length - 1);
      }
    } else if (key == 'CLEAR') {
      pinCtx.clear();
    } else if (RegExp(r'[0-9]').hasMatch(key)) {
      if (pinCtx.text.length < 6) {
        // Limit PIN to 6 digits
        pinCtx.text += key;
      }
    }
    password.value = pinCtx.text;
  }

  void startPinInput() {
    platform.invokeMethod('startPinInput');
  }

  void _listenToPinInput() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onPinInput') {
        final pin = call.arguments as String;
        pinCtx.text = pin;
        password.value = pin;
      } else if (call.method == 'onPinCancel') {
        pinCtx.clear();
        password.value = '';
      } else if (call.method == 'onPinError') {
        Get.snackbar('Error', 'PIN entry failed: ${call.arguments}');
      }
      return null;
    });
  }

  void handleError(String message) {
    AppAlert(
      title: 'login_error'.tr,
      message: message,
    ).showAlert();
  }

  void toggleFocus() {
    isPhoneFieldFocused = !isPhoneFieldFocused;
    if (!isPhoneFieldFocused) {
      startPinInput(); // Trigger PED PIN input when focusing password field
    }
  }

  void loginUtil(String pin, String username, String _phoneCode) {
    phoneCtx.text = username;
    pinCtx.text = pin;
    phoneCode.value = _phoneCode;
    userLogin();
  }

  @override
  void onInit() async {
    StorageService().removeToken();

    var _phone = await StorageService().getPhone();
    if (_phone.isNotEmpty) {
      phoneCtx.text = _phone;
      phone.value = _phone;
    }

    var remember = await StorageService().getRememberMe();
    rememberMe.value = remember;
    pinCtx.text = '';
    _listenToPinInput();

    super.onInit();
  }

  void setPhone() {
    phone.value = phoneCode.value + phoneCtx.text;

    if (phoneCtx.text.startsWith('0')) {
      phone.value = phoneCode.value + phoneCtx.text.replaceFirst('0', '');
    }
  }

  Future userLogin() async {
    setPhone();
    //await DeviceService.getDeviceInfo();

    var data = {
      'deviceId': '123',
      // 'terminalId': DeviceService.deviceId,
      'password': 'Password1@',
      'phoneNumber': phone.value,
    };

    isLoading.value = true;
    var res = await Api().post(Endpoints.LOGIN, data);
    isLoading.value = false;

    if (res.respCode == 0) {
      if (rememberMe.value) {
        StorageService().savePhone(phoneCtx.text);
        StorageService().saveRememberMe(true);
      } else {
        StorageService().savePhone('');
        StorageService().saveRememberMe(false);
      }
      globalCtx.token.value = res.data['token'];
      TokenService.token = res.data['token'];
       await posCtrl.keyExhange();

      globalCtx.barIndex.value = 0;
      Get.offAll(() => const HomeScreen());

      StorageService().saveToken(res.data['refreshToken']);
      StorageService().saveViewedWalkthrough();
    } else {
      handleError(res.respDesc);
    }
  }
}
