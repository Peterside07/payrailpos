import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/pos_controller.dart';
import 'package:payrailpos/controller/profile_controller.dart';
import 'package:payrailpos/controller/wallet_controller.dart';
import 'package:payrailpos/screen/home/transactions/transactions.dart';
import 'package:payrailpos/screen/home/withdraw/wallet_balance.dart';
import 'package:payrailpos/screen/home/withdraw/withdrawal_screen.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/buttons/primary_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final profileCtx = Get.put(ProfileController());
  final FocusNode _focusNode = FocusNode();
  final walletCtrl = Get.put(WalletController());
  final profileCtrl = Get.put(ProfileController());

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.digit1) {
        // Withdrawal
        print('Withdrawal');
        Get.to(() => const WithdrawalScreen());
      } else if (event.logicalKey == LogicalKeyboardKey.digit2) {
        // Transfer
        print('Transfer');
        //  Get.to(() => TransferScreen());
      } else if (event.logicalKey == LogicalKeyboardKey.digit3) {
        // Balance
        print('Balance');
        //  Get.to(() => BalanceScreen());
      } else if (event.logicalKey == LogicalKeyboardKey.digit4) {
        // Bills
        print('Bills');
        //  Get.to(() => BillsScreen());
      }
    }
  }

  @override
  void initState() {
    profileCtrl.getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    walletCtrl.callFetchAgentWallet();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: KeyboardListener(
        onKeyEvent: _handleKeyEvent,
        focusNode: _focusNode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WalletBalance(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionItem(
                  icon: 'dash_withdrawal',
                  label: 'action_withdraw'.tr,
                  toScreen: const SelectAccount(),
                ),
                ActionItem(
                  icon: 'dash_transfer',
                  label: 'History'.tr,
                  toScreen: TransactionScreen(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionItem(
                  icon: 'dash_balance',
                  label: 'Account'.tr,
                  // toScreen: ,
                ),
                ActionItem(
                  icon: 'dash_bills',
                  label: 'Services'.tr,
                  // toScreen: TransferScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class ActionItem extends StatelessWidget {
  final String icon;
  final String label;
  final Widget? toScreen;

  ActionItem({
    Key? key,
    required this.icon,
    required this.label,
    this.toScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.to(() => toScreen!);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/icons/$icon.png')),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class SelectAccount extends StatefulWidget {
  const SelectAccount({super.key});

  @override
  State<SelectAccount> createState() => _SelectAccountState();
}

final posControler = Get.put(POSController());

class _SelectAccountState extends State<SelectAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose Account Type',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                buttonColor: AppColors.PLACEHOLDER_COLOR,
                label: 'Current',
                onPressed: () {
                  posControler.selectedAccountType.value = '001'; // Savings

                  Get.to(() => const WithdrawalScreen());
                },
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                buttonColor: AppColors.PLACEHOLDER_COLOR,
                label: 'Savings',
                onPressed: () {
                  posControler.selectedAccountType.value = '000'; // Savings

                  Get.to(() => const WithdrawalScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
