import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/screen/home/transactions/transaction_item.dart';
import 'package:payrailpos/model/transaction_model.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/payment_receipt.dart';


class TransactionCard extends StatelessWidget {
  final TransactionModel item;
  final Function(TransactionModel)? onSelect;

  const TransactionCard({
    Key? key,
    required this.item,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const  EdgeInsets.symmetric(horizontal: kPADDING),
      color: Get.isDarkMode ? AppColors.DARK_BG_COLOR_2 : Colors.white,
      child: TransactionItem(
        item: item,
        onTap: onSelect != null
            ? () {
                onSelect!(item);
              }
            : () {
                Get.to(() => PaymentReceipt(transaction: item));
              },
      ),
    );
  }
}
