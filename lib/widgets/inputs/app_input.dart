import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payrailpos/theme/colors.dart';

class AppInput extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final String? suffixText;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final int? maxLength;
  final bool hideText;
  final List<TextInputFormatter>? inputFormatters;
  final bool isTextArea;
  final String? helperText;
  final String? errorText;
  final double bottomMargin;

  const AppInput({super.key, 
    this.controller,
    this.enabled = true,
    this.placeholder = '',
    this.textCapitalization = TextCapitalization.words,
    this.keyboardType = TextInputType.text,
    this.suffixText,
    this.suffixIcon,
    this.onChanged,
    this.maxLength,
    this.hideText = false,
    this.prefixIcon,
    this.prefix,
    this.inputFormatters,
    this.isTextArea = false,
    this.helperText,
    this.errorText,
    this.bottomMargin = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isTextArea ? null : 55,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppColors.DARK_BG_COLOR_2
            : AppColors.INPUT_BG_COLOR,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: TextField(
        enabled: enabled,
        textCapitalization: textCapitalization,
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        maxLength: maxLength,
        obscureText: hideText,
        inputFormatters: inputFormatters,
        maxLines: isTextArea ? 4 : 1,
        decoration: InputDecoration(
          contentPadding: isTextArea
              ? const EdgeInsets.symmetric(vertical: 20, horizontal: 15)
              : const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          hintText: '$placeholder',
          counterText: '',
          helperText: helperText,
          labelText: placeholder,
          errorText: errorText,
          labelStyle: TextStyle(
              color: Get.isDarkMode
                  ? AppColors.INPUT_BG_COLOR
                  : AppColors.TEXT_COLOR),
          hintStyle: const TextStyle(
            color: AppColors.PLACEHOLDER_COLOR,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          // filled: true,
          // fillColor: AppColors.INPUT_BG_COLOR,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(6),
          ),
          suffixText: suffixText,
          suffixStyle: TextStyle(
            color: Get.isDarkMode
                ? AppColors.INPUT_BG_COLOR
                : AppColors.DARK_COLOR,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          prefix: prefix,
        ),
        style: TextStyle(
          fontSize: 16,
          color:
              Get.isDarkMode ? AppColors.INPUT_BG_COLOR : AppColors.DARK_COLOR,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: AppColors.PRIMARY_COLOR,
      ),
    );
  }
}
