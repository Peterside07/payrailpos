import 'package:flutter/material.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinInput extends StatelessWidget {
  final int length;
  final bool hideText;
  final TextEditingController? controller;
  final Function(String val)? onChanged;

  PinInput({
    this.length = 6,
    this.hideText = true,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: length,
      obscureText: hideText,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeFillColor: AppColors.INPUT_BG_COLOR,
        borderWidth: 1,
        activeColor: AppColors.INPUT_BG_COLOR,
        inactiveColor: AppColors.INPUT_BG_COLOR,
        inactiveFillColor: AppColors.INPUT_BG_COLOR,
        selectedFillColor: AppColors.INPUT_BG_COLOR,
        selectedColor: AppColors.PRIMARY_COLOR,
      ),
      animationDuration: const Duration(milliseconds: 100),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      controller: controller,
      textStyle: const TextStyle(color: AppColors.TEXT_COLOR),
      onCompleted: (v) {},
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }
}
