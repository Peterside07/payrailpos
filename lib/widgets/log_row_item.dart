import 'package:flutter/material.dart';
import 'package:payrailpos/theme/colors.dart';

class LogRowItem extends StatelessWidget {
  final String value;
  final String label;

  const LogRowItem({
    Key? key,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.PRIMARY_COLOR,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
