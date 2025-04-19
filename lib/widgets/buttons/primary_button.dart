import 'package:flutter/material.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/loaders/loader.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final double height;
  final double textSize;
  final double borderRadius;
  final bool isLoading;
  final Color? textColor;

  PrimaryButton({
    this.label = 'Button',
    this.onPressed,
    this.buttonColor = AppColors.PRIMARY_COLOR,
    this.height = 56,
    this.textSize = 16,
    this.borderRadius = 28.0,
    this.isLoading = false,
    this.textColor,
  });

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.disabled
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.DISABLED_BUTTON_COLOR;
    }
    return buttonColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => getColor(states),
          ),
          elevation: MaterialStateProperty.all(0.0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: !isLoading
            ? Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: textColor ?? AppColors.DARK_COLOR,
                  fontSize: textSize,
                ),
              )
            : LoaderIcon(),
      ),
    );
  }
}
