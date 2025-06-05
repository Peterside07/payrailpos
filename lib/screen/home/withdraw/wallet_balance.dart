import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/wallet_controller.dart';
import 'package:payrailpos/extensions/double_extension.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/utils.dart';





class WalletBalance extends StatelessWidget {
  WalletBalance({Key? key}) : super(key: key);

  final walletCtrl = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.DARK_BG_COLOR_2 : Colors.white,
      //  boxShadow: [Utils.appBoxShadow()],
     //   borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
       //   SizedBox(height: 8),
          Text(
            'wallet_balance'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Obx(
            () => Text(
              '${walletCtrl.selectedWallet.value.currency?.name ?? NAIRA} ${walletCtrl.selectedWallet.value.balance!.toCurrencyFormat()}',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
       // const  SizedBox(height: 12),
         
        ],
      ),
    );
  }
}
