import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/profile_controller.dart';
import 'package:payrailpos/extensions/double_extension.dart';
import 'package:payrailpos/extensions/string_extension.dart';
import 'package:payrailpos/theme/colors.dart';

import '../../../global/constants.dart';
import '../../../model/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel item;
  final VoidCallback? onTap;

  TransactionItem({Key? key, required this.item, this.onTap}) : super(key: key);
  final profileCtx = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        leading: Image(
          image: AssetImage('assets/icons/${item.type.toImage()}'),
        ),
        title: Text(
          item.description ?? '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          '${item.transactionDate}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profileCtx.isBalanceVisible.value
                  ? '$NAIRA${item.amount?.toCurrencyFormat() ?? '0.0'}'
                  : '******',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              item.status,
              style: TextStyle(
                color: item.status.toLowerCase() == 'failed'
                    ? AppColors.STRONG_RED
                    : Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
