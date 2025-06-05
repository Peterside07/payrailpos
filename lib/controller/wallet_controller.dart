import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:payrailpos/controller/profile_controller.dart';
import 'package:payrailpos/controller/wallet_model.dart';
import 'package:payrailpos/model/wallet_transaction_model.dart';
import 'package:payrailpos/service/api.dart';
import 'package:payrailpos/widgets/utils.dart';

class WalletController extends GetxController {
  final profileController = Get.put(ProfileController());

  var wallets = <WalletModel>[].obs;
  var selectedWallet = WalletModel().obs;

  var walletTransactions = <WalletTransactionModel>[].obs;

  var isFetchingWallets = true.obs;
  var isLoadingHistory = false.obs;

  Future fetchAgentWallet() async {
    var res = await Api().get(
      'api/wallets/agents/${profileController.user.value.id}',
    );

    if (res.respCode == 0) {
      wallets.assignAll([]);
      for (var element in res.data) {
        wallets.add(WalletModel.fromJson(element));
      }
      if (wallets.length == 1) selectedWallet.value = wallets[0];
    }
  }

  void callFetchAgentWallet() async {
    if (wallets.length <= 0) {
      isFetchingWallets.value = true;
      await fetchAgentWallet();
      isFetchingWallets.value = false;
    }
  }

  void fetchWalletTransactions() async {
    isLoadingHistory.value = true;
    var purseId = selectedWallet.value.id;

    final currentDate = formatDate(DateTime.now());
    final sevenDaysAgo =
        formatDate(DateTime.now().subtract(Duration(days: 30)));

    var res = await Api().get(
      'api/wallet/$purseId/transaction/$sevenDaysAgo/$currentDate',
    );
    isLoadingHistory.value = false;

    if (res.respCode == 0) {
      walletTransactions.assignAll((res.data as List)
          .map((e) => WalletTransactionModel.fromJson(e))
          .toList());
    } else {
      Get.back();
      Utils.showAlert(res.respDesc);
    }
  }

  String formatDate(DateTime date) {
    return date.toString().split(' ')[0].split('-').reversed.join('-');
  }
}
