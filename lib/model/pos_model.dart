class PosTransactionModel {
  final String statuscode;
  final String message;
  final String terminalID;
  final String rrn;
  final String stan;
  final String amount;
  final String transactionTime;
  final String authcode;
  final String cardHolderName;
  final String cardExpireDate;
  final String maskedPan;
  final String pinType;
  final String aid;
  final String datetime;
  final String merchantId;
  final String merchantName;
  final String merchantAddress;
  final String deviceSerialNumber;
  final String bankLogo;
  final String baseAppVersion;
  final String currency;

  PosTransactionModel({
    this.statuscode = '',
    this.message = '',
    this.terminalID = '',
    this.rrn = '',
    this.stan = '',
    this.amount = '',
    this.transactionTime = '',
    this.authcode = '',
    this.cardHolderName = '',
    this.cardExpireDate = '',
    this.maskedPan = '',
    this.pinType = '',
    this.aid = '',
    this.datetime = '',
    this.merchantId = '',
    this.merchantName = '',
    this.merchantAddress = '',
    this.deviceSerialNumber = '',
    this.bankLogo = '',
    this.baseAppVersion = '',
    this.currency = '',
  });

  factory PosTransactionModel.fromJson(dynamic json) {
    return PosTransactionModel(
      statuscode: json['statuscode'] ?? '',
      message: json['statuscode'] == '06' ? 'Timeout' : json['message'] ?? '',
      terminalID: json['terminalID'] ?? '',
      rrn: json['rrn'] ?? '',
      stan: json['stan'] ?? '',
      amount: json['amount'] ?? '',
      transactionTime: json['datetime'] ?? json['transactionTime'] ?? '',
      authcode: json['authcode'] ?? '',
      cardHolderName: json['cardHolderName'] ?? '',
      cardExpireDate: json['cardExpireDate'] ?? '',
      maskedPan: json['maskedPan'] ?? '',
      pinType: json['pinType'] ?? '',
      aid: json['aid'] ?? '',
      datetime: json['datetime'] ?? '',
      merchantId: json['merchantId'] ?? '',
      merchantName: json['merchantName'] ?? 'AIROPAY LIMITED',
      merchantAddress: json['merchantAddress'] ?? 'Lagos, Nigeria',
      deviceSerialNumber: json['deviceSerialNumber'] ?? '',
      bankLogo: json['bankLogo'] ?? '/storage/emulated/0/image.png',
      baseAppVersion: json['baseAppVersion'] ?? '',
      currency: json['currency'] ?? '',
    );
  }
}


class PosParameterModel {
  final String terminalID;
  final String serialNo;
  final String ksn;
  final String sdkVersion;
  final String hardwareSN;

  PosParameterModel({
    required this.terminalID,
    this.serialNo = '',
    this.ksn = '',
    this.sdkVersion = '',
    this.hardwareSN = '',
  });

  factory PosParameterModel.fromJson(Map<String, dynamic> json) {
    return PosParameterModel(
      terminalID: json['terminalID'] ?? '',
      serialNo: json['serialNo'] ?? '',
      ksn: json['ksn'] ?? '',
      sdkVersion: json['sdkVersion'] ?? '',
      hardwareSN: json['hardwareSN'] ?? '',
    );
  }
}

// class PosParameterModel {
//   final String billerID;
//   final String merchantID;
//   final String terminalID;
//   final String serialNumber;
//   final String baseAppVersion;
//   final String merchantCategoryCode;

//   PosParameterModel({
//     this.billerID = '',
//     this.merchantID = '',
//     this.terminalID = '',
//     this.serialNumber = '',
//     this.baseAppVersion = '',
//     this.merchantCategoryCode = '',
//   });

//   factory PosParameterModel.fromJson(dynamic json) {
//     return PosParameterModel(
//       billerID: json['BillerID'] ?? '',
//       merchantID: json['MerchantID'] ?? '',
//       terminalID: json['TerminalID'] ?? '',
//       serialNumber: json['serialNumber'] ?? '',
//       baseAppVersion: json['baseAppVersion'] ?? '',
//       merchantCategoryCode: json['MerchantCategoryCode'] ?? '',
//     );
//   }
// }
