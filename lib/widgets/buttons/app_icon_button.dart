import 'package:flutter/material.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/loaders/loader.dart';

class AppIconButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final double height;
  final double textSize;
  final double borderRadius;
  final bool isLoading;
  final Color? textColor;
  final IconData icon;
  final Color? iconColor;

  AppIconButton({
    this.label = 'Button',
    this.onPressed,
    this.buttonColor = AppColors.PRIMARY_COLOR,
    this.height = 56,
    this.textSize = 14,
    this.borderRadius = 28.0,
    this.isLoading = false,
    this.textColor,
    required this.icon,
    this.iconColor,
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
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18, color: iconColor),
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
        label: !isLoading
            ? Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                  fontSize: textSize,
                ),
              )
            : LoaderIcon(),
      ),
    );
  }
}
