import 'package:flutter/material.dart';
import 'package:payrailpos/widgets/inputs/app_input.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController? controller;
  final String placeholder;
  final Function(String)? onChanged;

  PhoneInput({
    this.controller,
    this.placeholder = 'Phone number',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          child: AppInput(
            controller: TextEditingController(text: '+234'),
            enabled: false,
          ),
        ),
        SizedBox(width: 12.0),
        Expanded(
          flex: 1,
          child: AppInput(
            placeholder: placeholder,
            controller: controller,
            keyboardType: TextInputType.none,
            onChanged: onChanged,
            maxLength: 11,
          ),
        ),
      ],
    );
  }
}
