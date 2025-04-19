import 'package:payrailpos/model/pos_model.dart';
import 'package:payrailpos/service/pos_service.dart';

dynamic receiptJson(
  PosTransactionModel res, {
  ReceiptType type = ReceiptType.CUSTOMER,
}) {
//  final global = Get.put(GlobalController());

  return {
    "Receipt": [
      {
        "Bitmap":
            res.bankLogo.isEmpty ? '/storage/emulated/0/image.png' : res.bankLogo,
        "letterSpacing": 5,
        "String": [
          {
            "isMultiline": true,
            "header": {
              "text":
                  "****${type == ReceiptType.CUSTOMER ? 'CUSTOMER' : 'MERCHANT'} COPY****",
              "isBold": true
            },
            "body": {"text": ""}
          },
          {
            "isMultiline": true,
            "header": {"text": "Merchant Name", "align": "left"},
            "body": {"text": res.merchantName, "align": "left"}
          },
          {
            "isMultiline": false,
            "header": {"text": "Merchant ID", "align": "left"},
            "body": {"text": " ${res.merchantId}"}
          },
          {
            "isMultiline": false,
            "header": {"text": "Location", "align": "left"},
            "body": {"text": " ${res.merchantAddress}"}
          },
          {
            "isMultiline": false,
            "header": {"text": "Terminal ID", "align": "left"},
            "body": {"text": " ${res.terminalID}"}
          },
          {
            "isMultiline": true,
            "header": {"text": "--------------------------------"},
            "body": {"text": ""}
          },
          {
            "isMultiline": true,
            "header": {"text": "PURCHASE", "isBold": true},
            "body": {"text": ""}
          },
          {
            "isMultiline": false,
            "header": {"text": "STAN", "align": "left"},
            "body": {"text": " ${res.stan}"}
          },
          {
            "isMultiline": false,
            "header": {"text": "DATE/TIME", "align": "left"},
            "body": {"text": " ${res.transactionTime}"}
          },
          {
            "isMultiline": true,
            "header": {"text": "--------------------------------"},
            "body": {"text": ""}
          },
          {
            "isMultiline": false,
            "header": {"text": "Amount", "align": "left"},
            "body": {"text": "NGN ${res.amount}", "align": "right"}
          },
          {
            "isMultiline": true,
            "header": {"text": "--------------------------------"},
            "body": {"text": ""}
          },
          {
            "isMultiline": true,
            "header": {"text": "Debit Mastercard", "align": "left"},
            "body": {"text": ""}
          },
          {
            "isMultiline": true,
            "header": {"text": res.maskedPan, "isBold": true},
            "body": {"text": ""}
          },
          {
            "isMultiline": true,
            "header": {"text": res.cardHolderName, "align": "left"},
            "body": {"text": ""}
          },
          {
            "isMultiline": false,
            "header": {"text": "Exp Date", "align": "left"},
            "body": {"text": res.cardExpireDate, "align": "left"}
          },
          {
            "isMultiline": false,
            "header": {"text": "Auth Code", "align": "left"},
            "body": {"text": res.authcode, "align": "left"}
          },
          {
            "isMultiline": true,
            "header": {"text": res.pinType, "align": "left"},
            "body": {"text": ""}
          },
          {
            "isMultiline": true,
            "header": {"text": "--------------------------------"},
            "body": {"text": ""}
          },
          {
            "isMultiline": true,
            "header": {
              "text": res.message.toUpperCase(),
              "size": "large",
              "isBold": true
            },
            "body": {"text": ""}
          },
          {
            "isMultiline": false,
            "header": {"text": "Response Code", "align": "left"},
            "body": {"text": res.statuscode, "align": "left"}
          },
          {
            "isMultiline": true,
            "header": {"text": res.message, "align": "left"},
            "body": {"text": ""}
          },
          {
            "isMultiline": false,
            "header": {"text": "AID", "align": "left"},
            "body": {"text": res.aid, "align": "left"}
          },
          {
            "isMultiline": false,
            "header": {"text": "Reference Number", "align": "left"},
            "body": {"text": res.rrn, "align": "left"}
          },
          {
            "isMultiline": true,
            "header": {
              "text": "${res.baseAppVersion} PAYRAIL}",
              "align": "left"
            },
            "body": {"text": ""}
          },
          {
            "isMultiline": true,
            "header": {"text": "--------------------------------"},
            "body": {"text": ""}
          },
        ],
      }
    ]
  };
}
