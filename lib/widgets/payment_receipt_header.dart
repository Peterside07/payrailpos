import 'package:flutter/material.dart';
import 'package:payrailpos/extensions/double_extension.dart';
import 'package:payrailpos/extensions/string_extension.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/theme/colors.dart';


class PaymentReceiptHeader extends StatelessWidget {
  final double amount;
  final String status;
  final String transactionType;
  final Color statusColor;
  final String icon;

  PaymentReceiptHeader({
    Key? key,
    required this.amount,
    required this.status,
    required this.transactionType,
    this.statusColor = AppColors.PRIMARY_COLOR,
    this.icon = 'assets/icons/transfer.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 50,
          height: 50,
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$NAIRA${amount.toCurrencyFormat()}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    transactionType.typeCapitalize(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            Image(
              image: AssetImage(icon),
            ),
          ],
        ),
      ],
    );
  }
}
