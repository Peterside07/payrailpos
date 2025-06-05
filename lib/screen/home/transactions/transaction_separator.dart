import 'package:flutter/material.dart';
import 'package:payrailpos/global/constants.dart';

class TransactionSeparator extends StatelessWidget {
  final String text;

  TransactionSeparator(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: kPADDING,
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}
