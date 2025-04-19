import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/inputs/app_input.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? placeholder;
  final bool enabled;
  final int decimalDigits;

  AmountInput({
    this.controller,
    this.onChanged,
    this.placeholder = 'Enter amount',
    this.enabled = true,
    this.decimalDigits = 2,
  });

  @override
  Widget build(BuildContext context) {
    return AppInput(
      enabled: enabled,
      placeholder: placeholder ?? 'Amount',
      suffixIcon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            NAIRA,
            style: TextStyle(
              fontSize: 16,
              color: Get.isDarkMode
                  ? AppColors.TEXT_LIGHT_COLOR
                  : Color(0xff011405),
            ),
          )
        ],
      ),
      inputFormatters: [
       // CurrencyTextInputFormatter(symbol: '', decimalDigits: decimalDigits),
      ],
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }
}
