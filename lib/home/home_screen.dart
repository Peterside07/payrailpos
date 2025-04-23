import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payrailpos/home/withdraw/withdrawal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final profileCtx = Get.put(ProfileController());
  final FocusNode _focusNode = FocusNode();

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
  void dispose() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Obx(
            //   () =>
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(top: 10, left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: !Get.isDarkMode ? Colors.white : Colors.grey.shade900,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'wallet_balance'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  Text(
                    '100,000,000',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            //   ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionItem(
                  icon: 'dash_withdrawal',
                  label: 'action_withdraw'.tr,
                  toScreen: const WithdrawalScreen(),
                ),
                ActionItem(
                  icon: 'dash_transfer',
                  label: 'action_transfer'.tr,
                  // toScreen: TransferScreen(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionItem(
                  icon: 'dash_balance',
                  label: 'action_balance'.tr,
                  // toScreen: WithdrawalScreen(),
                ),
                ActionItem(
                  icon: 'dash_bills',
                  label: 'action_bills'.tr,
                  // toScreen: TransferScreen(),
                ),
                // ActionItem(
                //   icon: 'dash_transfer',
                //   label: 'action_vas'.tr,
                //   // toScreen: HistoryScreen(),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: KeyboardListener(
//         focusNode: FocusNode(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome'.tr,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge
//                   ?.copyWith(fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ActionItem(
//                   icon: 'dash_deposit',
//                   label: 'action_deposit'.tr,
//                   //  toScreen: DepositOneScreen(),
//                 ),
//                 ActionItem(
//                   icon: 'dash_withdrawal',
//                   label: 'action_withdraw'.tr,
//                   //   toScreen: WithdrawalScreen(),
//                 ),
//                 ActionItem(
//                   icon: 'dash_bills',
//                   label: 'action_bills'.tr,

//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ActionItem(
//                   icon: 'dash_balance',
//                   label: 'action_balance'.tr,
//                   //  toScreen: EnquiryScreen(),
//                 ),
//                 ActionItem(
//                   icon: 'dash_loan',
//                   label: 'action_loans'.tr,
//                   //toScreen: LoanScreen(),
//                 ),
//                 ActionItem(
//                   icon: 'dash_transfer',
//                   label: 'action_vas'.tr,
//                   //  toScreen: VasWelcome(),
//                 ),
//                 // Expanded(child: SizedBox())
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
