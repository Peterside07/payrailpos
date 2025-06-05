import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/extensions/double_extension.dart';
import 'package:payrailpos/extensions/string_extension.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/model/transaction_model.dart';
import 'package:payrailpos/model/transaction_summary_model.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/buttons/primary_button.dart';
import 'package:payrailpos/widgets/issue_log_container.dart';
import 'package:payrailpos/widgets/log_row_item.dart';
import 'package:payrailpos/widgets/payment_receipt_header.dart';
import 'package:payrailpos/widgets/transaction_service.dart';
import 'package:payrailpos/widgets/utils.dart';


class PaymentReceipt extends StatelessWidget {
  final TransactionModel transaction;
  final String? bankName;
  final String? accountName;
  final String? narration;

  final DEFAULT_STRING = '****';

  PaymentReceipt({
    Key? key,
    required this.transaction,
    this.bankName,
    this.accountName,
    this.narration,
  }) : super(key: key);






  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.appBar(context),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<TransactionSummaryModel>(
              future: TransactionService().getTransactionSummary(
                transactionType: transaction.type,
                amount: transaction.amount.toString(),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Expanded(
                        child:  Container(
                            color: Get.isDarkMode
                                ? AppColors.DARK_BG_COLOR
                                : Colors.white,
                            child: ListView(
                              padding: EdgeInsets.all(kPADDING),
                              children: [
                                PaymentReceiptHeader(
                                  amount: transaction.amount ?? 0,
                                  status: transaction.status,
                                  transactionType:
                                      transaction.type.typeCapitalize(),
                                  statusColor:
                                      transaction.status.toLowerCase() ==
                                              'failed'
                                          ? AppColors.STRONG_RED
                                          : Colors.green,
                                  icon:
                                      'assets/icons/${transaction.type.toImage()}',
                                ),
                                SizedBox(height: 20),
                                IssueLogContainer(
                                  child: Column(
                                    children: [
                                      LogRowItem(
                                        value: transaction.description
                                                ?.typeCapitalize() ??
                                            '',
                                        label: 'tran_type'.tr,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                IssueLogContainer(
                                  child: Column(
                                    children: [
                                      LogRowItem(
                                        value: paymentTo(),
                                        label: 'payment_to'.tr,
                                      ),
                                      bankName != null && accountName != null
                                          ? Column(
                                              children: [
                                                SizedBox(height: 16),
                                                LogRowItem(
                                                  value: transaction.type
                                                              .toLowerCase() ==
                                                          'payrail_deposit'
                                                      ? 'Payrail'
                                                      : bankName ?? '',
                                                  label: 'bank_name'.tr,
                                                ),
                                                SizedBox(height: 16),
                                                LogRowItem(
                                                  value: accountName ?? '',
                                                  label: 'account_name'.tr,
                                                ),
                                              ],
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                IssueLogContainer(
                                  child: Column(
                                    children: [
                                      LogRowItem(
                                        value:
                                            '$NAIRA${snapshot.data?.fee.toCurrencyFormat() ?? ''}',
                                        label: 'fee'.tr,
                                      ),
                                      SizedBox(height: 16),
                                      LogRowItem(
                                        value:
                                            '$NAIRA${transaction.amount?.toCurrencyFormat() ?? 0}',
                                        label: 'amount'.tr,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                IssueLogContainer(
                                  child: Column(
                                    children: [
                                      LogRowItem(
                                        value: transaction.tranRef ??
                                            DEFAULT_STRING,
                                        label: 'transaction_id'.tr,
                                      ),
                                      SizedBox(height: 16),
                                      LogRowItem(
                                        value: transaction.transactionDate ??
                                            DEFAULT_STRING,
                                        label: 'date'.tr,
                                      ),
                                      narration != null
                                          ? Column(
                                              children: [
                                                SizedBox(height: 16),
                                                LogRowItem(
                                                  value: narration!,
                                                  label: 'narration'.tr,
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                     
                    ],
                  );
                }

                if (snapshot.hasError) {
               //   return ErrorBox(error: snapshot.error.toString());
                }

                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  String paymentTo() {
    switch (transaction.type.toLowerCase()) {
      case 'transfer':
        return transaction.destinationAccount ?? DEFAULT_STRING;
      case 'deposit':
        return transaction.destinationAccount ?? DEFAULT_STRING;
      case 'payrail_deposit':
        return transaction.destinationAccount ?? DEFAULT_STRING;
      case 'withdrawal':
        return transaction.customerName ?? DEFAULT_STRING;
      case 'airtime_recharge':
        return transaction.customerPhoneNumber ?? DEFAULT_STRING;
      case 'data_recharge':
        return transaction.customerPhoneNumber ?? DEFAULT_STRING;
      case 'electricity_recharge':
        return transaction.customerName ?? DEFAULT_STRING;
      default:
        return DEFAULT_STRING;
    }
  }
}
