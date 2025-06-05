import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:payrailpos/controller/global_controller.dart';
import 'package:payrailpos/controller/profile_controller.dart';
import 'package:payrailpos/enums/tran_type.dart';
import 'package:payrailpos/global/endpoints.dart';
import 'package:payrailpos/model/pos_model.dart';
import 'package:payrailpos/model/transaction_summary_model.dart';
import 'package:payrailpos/service/api.dart';
import 'package:payrailpos/service/pos_service.dart';
import 'package:payrailpos/widgets/success_widget.dart';

// class TransactionService {
//   Future<List> getAgentTransactions(
//     int agentId, {
//     String? startDate,
//     String? endDate,
//   }) async {
//     var dt = DateTime.now().subtract(const Duration(days: 7));

//     var from = startDate ?? DateFormat("dd-MM-yyyy").format(dt);
//     var to = endDate ?? DateFormat("dd-MM-yyyy").format(DateTime.now());

//     var res = await Api().post(
//       'api/transaction/wallet/findTransactions',
//       {'agentId': agentId, 'from': from, 'to': to},
//     );
//     if (res.respCode == 0) return res.data;
//     return [];
//   }

class TransactionService {
  Future<List<dynamic>> getAgentTransactions(
    int agentId, {
    String? startDate,
    String? endDate,
  }) async {
    var dt = DateTime.now().subtract(const Duration(days: 7));

    var from = startDate ?? DateFormat("dd-MM-yyyy").format(dt);
    var to = endDate ?? DateFormat("dd-MM-yyyy").format(DateTime.now());

    var res = await Api().post(
      'api/transaction/wallet/findTransactions',
      {
        'agentId': agentId,
        'from': from,
        'to': to,
      },
    );

    // Assuming res.data is a Map<String, dynamic>
    if (res.respCode == 0 && res.data['body'] is List) {
      return List<dynamic>.from(res.data['body']);
    }

    return [];
  }

  Future<TransactionSummaryModel> getTransactionSummary({
    TranType? type,
    required String amount,
    String transactionType = '',
  }) async {
    print(amount);
    var tranType = type != null ? type.value : transactionType;
    var res = await Api().get(
      '${Endpoints.TRANSACTION_SUMMARY}?amount=${(double.tryParse(amount.replaceAll(',', '')) ?? 0).abs()}&tranType=$tranType',
    );

    if (res.respCode == 0) {
      return TransactionSummaryModel.fromJson(res.data);
    } else {
      return TransactionSummaryModel(
        fee: 0,
        originalAmount: 0,
        amountToDebit: 0,
      );

    }
  }

  static void printTransactionReceipt({
    required String message,
    required String amount,
    String? bankName,
    String? accountName,
    int? tranId,
    required String type,
  }) {
    final date = DateFormat("dd-MM-yyyy h:mm a").format(DateTime.now());

    final profile = Get.put(ProfileController());

    PosTransactionModel posModel = PosTransactionModel(
      amount: amount,
      terminalID: Get.put(GlobalController()).deviceId.value,
      datetime: date,
      message: '$type completed successfully',
      transactionTime: date,
      rrn: tranId.toString(),
      merchantName: (profile.user.value.businessName ?? profile.fullName.text) +
          " (Angala Financial Technologies Limited)",
    );

    PosService.doPrint(posModel);

    Get.to(
      () => SuccessWidget(
        bankName: bankName,
        accountName: accountName,
        tranId: tranId,
        message: message,
        secondBtnText: "Merchant Receipt",
        handleSecondBtn: () => PosService.doPrint(
          posModel,
          type: ReceiptType.MERCHANT,
        ),
      ),
    );
  }
}
