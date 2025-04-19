import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/home/withdraw/select_account.dart';
import 'package:payrailpos/widgets/buttons/primary_button.dart';
import 'package:payrailpos/widgets/inputs/app_input.dart';
import 'package:payrailpos/widgets/utils.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus to capture keyboard events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Handle terminal keyboard input
  // void _handleKeyEvent(KeyEvent event) {
  //   if (event is KeyDownEvent) {
  //     // Handle Enter key (green "O" on terminal) to confirm withdrawal
  //     if (event.logicalKey == LogicalKeyboardKey.enter) {
  //       _submitWithdrawal();
  //     }
  //     // Handle Escape or "X" key (red "X" on terminal) to dismiss
  //     else if (event.logicalKey == LogicalKeyboardKey.escape) {
  //       Get.back();
  //     }
  //     // Handle numeric input (0-9)
  //     else if (event.logicalKey.keyLabel != null &&
  //         RegExp(r'[0-9]').hasMatch(event.logicalKey.keyLabel)) {
  //       setState(() {
  //         _amountController.text += event.logicalKey.keyLabel;
  //       });
  //     }
  //     // Handle backspace (yellow "<" on terminal)
  //     else if (event.logicalKey == LogicalKeyboardKey.backspace) {
  //       setState(() {
  //         if (_amountController.text.isNotEmpty) {
  //           _amountController.text = _amountController.text
  //               .substring(0, _amountController.text.length - 1);
  //         }
  //       });
  //     }
  //   }
  // }

  void _submitWithdrawal() {
    if (_amountController.text.isEmpty) {
      AppAlert(
        title: 'Error',
        message: 'Please enter an amount to withdraw',
      ).showAlert();
      return;
    }
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      AppAlert(
        title: 'Error',
        message: 'Please enter a valid amount',
      ).showAlert();
      return;
    }
    // Proceed with withdrawal logic (e.g., API call)
    // Get.snackbar('Success', 'withdrawal_submitted'.tr);
    // Get.back();
    print('Withdrawal submitted: $amount');
    Get.to(() =>  SelectAccount(
        amount: amount,
    ));
    // Add your withdrawal logic here
    // For example, you can call an API to process the withdrawal
    // and then show a success message or navigate to another screen.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        //  onKeyEvent: _handleKeyEvent,
        autofocus: true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter amount to withdraw',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 100,
                child: AppInput(
                  isTextArea: false,
                  prefixIcon: const Icon(
                    Icons.monetization_on,
                    color: Colors.black,
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.none,
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Proceed',
                onPressed: () {
                  _submitWithdrawal();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
