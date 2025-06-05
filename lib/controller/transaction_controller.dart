import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:payrailpos/controller/profile_controller.dart';
import 'package:payrailpos/global/endpoints.dart';
import 'package:payrailpos/model/transaction_model.dart';
import 'package:payrailpos/service/api.dart';
import 'package:payrailpos/widgets/transaction_service.dart';
import 'package:payrailpos/widgets/utils.dart';

class TransactionController extends GetxController {
  final profileCtx = Get.put(ProfileController());

  var transactions = <TransactionModel>[].obs;
  var todayTransactions = <TransactionModel>[].obs;
  var yesterdayTransactions = <TransactionModel>[].obs;
  var filteredTransaction = <TransactionModel>[].obs;
  var allTransactions = <TransactionModel>[].obs;
  var areTransactionsPresent = false.obs;
  var isLoading = true.obs;

  Future fetchTransactions() async {
    var dt = returnFormattedDate(DateTime.now().subtract(const Duration(days: 2)));
    var list = await TransactionService().getAgentTransactions(
      profileCtx.user.value.id,
      endDate: dt,
    );
    transactions.assignAll(list.map((e) => TransactionModel.fromJson(e)));
  }

  Future fetchTodayTransactions() async {
    var list = await TransactionService().getAgentTransactions(
      profileCtx.user.value.id,
      startDate: returnFormattedDate(DateTime.now()),
      endDate: returnFormattedDate(DateTime.now()),
    );
    todayTransactions.assignAll(list.map((e) => TransactionModel.fromJson(e)));
  }

  Future fetchYesterdayTransactions() async {
    var dt = returnFormattedDate(DateTime.now().subtract(Duration(days: 1)));
    var list = await TransactionService().getAgentTransactions(
      profileCtx.user.value.id,
      startDate: dt,
      endDate: dt,
    );
    yesterdayTransactions
        .assignAll(list.map((e) => TransactionModel.fromJson(e)));
  }

  void callFetchTransactions() async {
    isLoading.value = true;
    await fetchTransactions();
    await fetchTodayTransactions();
    await fetchYesterdayTransactions();
    allTransactions.assignAll(
      [...transactions],
    );
    areTransactionsPresent.value = todayTransactions.length > 0 ||
        yesterdayTransactions.length > 0 ||
        filteredTransaction.length > 0 ||
        transactions.length > 0;
    isLoading.value = false;
  }

  Future searchTransaction(String query) async {
    var data = {
      'agentId': profileCtx.user.value.id,
    };
    var response = await Api().post(Endpoints.GET_TRANSACTIONS, data);

    if (response.respCode == 0) {
    
      filteredTransaction.assignAll(
        response.data.map((e) => TransactionModel.fromJson(e)),
      );
    } else {
      Utils.showAlert(response.respDesc);
    }
  }

  Future fetchFilteredTransactions(DateTime startDate, DateTime endDate) async {
    isLoading.value = true;
    var list = await TransactionService().getAgentTransactions(
      profileCtx.user.value.id,
      startDate: returnFormattedDate(startDate),
      endDate: returnFormattedDate(endDate),
    );
    isLoading.value = false;
    filteredTransaction
        .assignAll(list.map((e) => TransactionModel.fromJson(e)));
  }

  String returnFormattedDate(DateTime date) {
    return date.toString().split(' ')[0].split('-').reversed.join('-');
  }
}
