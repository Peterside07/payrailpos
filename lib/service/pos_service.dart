import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:payrailpos/global/config.dart';
import 'package:payrailpos/global/receipt.dart';
import 'package:payrailpos/model/pos_model.dart';
import 'package:payrailpos/service/storage.dart';
import 'package:payrailpos/widgets/utils.dart';


enum ReceiptType { MERCHANT, CUSTOMER }

class PosService {
  static const platform = const MethodChannel('com.standard.app/pos');

  static void invokeKeyExchange() async {
    var isDone = await StorageService().getExchange();

    if (!isDone) {
      try {
        await platform.invokeMethod('doKeyExchange');
        StorageService().saveExchange();
      } on PlatformException {
        SystemNavigator.pop();
      }
    }

    getParameters();
  }

  static Future<PosParameterModel> getParameters() async {
    var result = await platform.invokeMethod('doGetParameters');
    var parameters = PosParameterModel.fromJson(jsonDecode(result));
    print('PARAMETERS: $parameters');
   // Get.put(GlobalController()).setDeviceDetails(parameters);
    return parameters;
  }

  static Future<PosTransactionModel> doCardTransaction(
    String amount,
    String ref,
  ) async {
    try {
      var result = await platform.invokeMethod(
        'doCardTransaction',
        {'amount': amount, 'ref': ref},
      );

      return PosTransactionModel.fromJson(jsonDecode(result));
    } on PlatformException catch (e) {
      handleException(e);
      return PosTransactionModel.fromJson({
        'statuscode': '99',
        'message': e.message.toString(),
      });
    }
  }

  static void doSettings() async {
    try {
      var result = await platform.invokeMethod('doSettings');
      return result;
    } on PlatformException catch (e) {
      handleException(e);
    }
  }

  static void doPrint(
    PosTransactionModel res, {
    ReceiptType type = ReceiptType.CUSTOMER,
  }) async {
    // final extDir = await getExternalStorageDirectory();
    // final path = extDir != null
    //     ? extDir.path + '/images/logo.png'
    //     : '/storage/emulated/0/image.png';

    try {
      var result = await platform.invokeMethod('doPrint', {
        'doc': jsonEncode(receiptJson(res, type: type)),
      });
      return result;
    } on PlatformException catch (e) {
      handleException(e);
    }
  }

  static void doRePrint() async {
    try {
      var result = await platform.invokeMethod('doRePrint');
      return result;
    } on PlatformException catch (e) {
      handleException(e);
    }
  }

  static void handleException(PlatformException e) {
    debugPrint(e.toString());
    debugPrint(e.code);
    debugPrint(e.details.toString());
    debugPrint(e.message);
  }

  static void completePosPayment() {}

  static Future<void> postTransaction(
    PosTransactionModel tran, {
    required String tranRef,
    VoidCallback? onSuccess,
  }) async {
   // final globalCtrl = Get.put(GlobalController());
  //  Position position = await Utils.determinePosition();
    // String device =
    //     tran.terminalID.isEmpty ? globalCtrl.deviceId.value : tran.terminalID;

    var toHash = tran.transactionTime +
        tran.amount.split('.')[0] +
        tranRef +
        (tran.statuscode == "00" ? "SUCCESSFUL" : "FAILED") +
        'ga' +
   //     device +
        AppConfig.HASH_KEY;

    var encoded = utf8.encode(toHash);
 //   var hashedString = sha512.convert(encoded);

    var data = {
      "amount": tran.amount.split('.')[0],
    //  "hash": hashedString.toString(),
      "ptsp": "ga",
      "status": (tran.statuscode == "00" ? "SUCCESSFUL" : "FAILED"),
   //   "terminalId": device,
      "transactionDate": tran.transactionTime,
      "transactionReference": tranRef,
      "maskedPan": tran.maskedPan,
      "cardExpiry": tran.cardExpireDate,
      "cardHash": tran.hashCode,
      "stan": tran.stan,
      "currency": tran.currency,
      "merchantId": tran.merchantId,
      "retrievalReferenceNumber": tran.rrn,
      "location": {
   //     'longitude': position.longitude,
       // 'latitude': position.latitude
      }
    };

    try {
      await Dio().post(
        'https://b2bapis.payrail.co/integration/ga/',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (onSuccess != null) onSuccess();
    } on DioError catch (e) {
      Utils.showAlert(e.response?.data['respDesc'] ?? e.error.toString());
    }
  }
}
