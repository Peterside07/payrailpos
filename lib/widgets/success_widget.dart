// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/global_controller.dart';
import 'package:payrailpos/controller/transaction_controller.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/screen/home/home_screen.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/buttons/primary_button.dart';
import 'package:payrailpos/widgets/payment_receipt.dart';


class SuccessWidget extends StatelessWidget {
  final VoidCallback? onDone;
  final String title;
  final String message;
  final String? image;
  final String mainBtnText;
  final String? secondBtnText;
  final VoidCallback? handleSecondBtn;
  final Widget? body;
  final int? tranId;
  final String? bankName;
  final String? accountName;
  final String? narration;

  SuccessWidget({
    Key? key,
    this.onDone,
    this.title = 'Transaction Successful',
    this.message = '',
    this.image,
    this.mainBtnText = 'Awesome',
    this.secondBtnText,
    this.handleSecondBtn,
    this.body,
    this.tranId,
    this.accountName,
    this.bankName,
    this.narration,
  }) : super(key: key);

  final globalCtrl = Get.put(GlobalController());
  final transactionCtrl = Get.put(TransactionController());

  void receipt() async {
    if (tranId != null) {
      await transactionCtrl.fetchTodayTransactions();
      var transaction = transactionCtrl.todayTransactions
          .where((p0) => p0.id == tranId)
          .first;
      Get.to(
        () => PaymentReceipt(
          transaction: transaction,
          bankName: bankName,
          accountName: accountName,
          narration: narration,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kPADDING),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(image ?? 'assets/images/thumb.png'),
                      ),
                      SizedBox(height: 22),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 22),
                      Text(
                        message,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      body ?? SizedBox()
                    ],
                  ),
                ),
                tranId != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryButton(
                            label: 'View Receipt',
                            onPressed: () => receipt(),
                            buttonColor: AppColors.PRIMARY_LIGHT_COLOR,
                            textColor: AppColors.PRIMARY_COLOR,
                          ),
                          SizedBox(height: 20),
                        ],
                      )
                    : SizedBox(),
                PrimaryButton(
                  label: mainBtnText,
                  onPressed: () {
                    if (onDone != null) {
                      onDone!();
                    } else {
                      globalCtrl.barIndex.value = 0;
                      Get.offAll(() => HomeScreen());
                    }
                  },
                ),
                secondBtnText != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          PrimaryButton(
                            label: secondBtnText!,
                            onPressed: () {
                              if (handleSecondBtn != null) {
                                handleSecondBtn!();
                              } else {
                                globalCtrl.barIndex.value = 0;
                                Get.offAll(() => HomeScreen());
                              }
                            },
                            buttonColor: AppColors.PRIMARY_LIGHT_COLOR,
                            textColor: AppColors.PRIMARY_COLOR,
                          ),
                        ],
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
