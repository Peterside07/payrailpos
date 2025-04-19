import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payrailpos/home/home_screen.dart';

class SelectAccount extends StatefulWidget {
  const SelectAccount({super.key, required this.amount});

  final double amount;

  @override
  State<SelectAccount> createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0; // 0: Default, 1: Savings, 2: Current
  final List<String> _accountTypes = ['savings'.tr, 'current'.tr];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // void _handleKeyEvent(RawKeyEvent event) {
  //   if (event is RawKeyDownEvent) {
  //     // Handle number keys (1, 2, 3) for direct selection
  //     if (event.logicalKey == LogicalKeyboardKey.digit1) {
  //       setState(() {
  //         _selectedIndex = 0; // Default
  //       });
  //       _proceed();
  //     } else if (event.logicalKey == LogicalKeyboardKey.digit2) {
  //       setState(() {
  //         _selectedIndex = 1; // Savings
  //       });
  //       _proceed();
  //     } else if (event.logicalKey == LogicalKeyboardKey.digit3) {
  //       setState(() {
  //         _selectedIndex = 2; // Current
  //       });
  //       _proceed();
  //     }
  //     // Handle arrow keys for navigation
  //     else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
  //       setState(() {
  //         _selectedIndex =
  //             (_selectedIndex - 1).clamp(0, _accountTypes.length - 1);
  //       });
  //     } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
  //       setState(() {
  //         _selectedIndex =
  //             (_selectedIndex + 1).clamp(0, _accountTypes.length - 1);
  //       });
  //     }
  //     // Handle Enter key (green "O") to confirm selection
  //     else if (event.logicalKey == LogicalKeyboardKey.enter) {
  //       _proceed();
  //     }
  //     // Handle Escape key (red "X") to go back
  //     else if (event.logicalKey == LogicalKeyboardKey.escape) {
  //       Get.back();
  //     }
  //   }
  // }

  void _proceed() {
    String? code;
    if (_selectedIndex == 1) {
      code = "01110000"; // Savings
    } else if (_selectedIndex == 2) {
      code = "100"; // Current
    }
    // Navigate to the next screen with amount and code
    Get.to(() => ConfirmWithdrawalScreen(
          amount: widget.amount,
          accountType: _accountTypes[_selectedIndex],
          code: code,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Account Type',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _accountTypes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      _proceed();
                    },
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: _selectedIndex == index
                              ? Colors.blue
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      color: _selectedIndex == index
                          ? Colors.blue.shade50
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              _accountTypes[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _selectedIndex == index
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: _selectedIndex == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmWithdrawalScreen extends StatelessWidget {
  final double amount;
  final String accountType;
  final String? code;

  const ConfirmWithdrawalScreen({
    Key? key,
    required this.amount,
    required this.accountType,
    this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('confirm_withdrawal'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('amount'.tr + ': ₦${amount.toStringAsFixed(2)}'),
            Text('account_type'.tr + ': $accountType'),
            if (code != null) Text('code'.tr + ': $code'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Proceed with withdrawal logic
                Get.snackbar('success'.tr, 'withdrawal_submitted'.tr);
                Get.offAll(() => HomeScreen()); // Replace with your HomeScreen
              },
              child: Text('confirm'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
