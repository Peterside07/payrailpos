import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/global/endpoints.dart';
import 'package:payrailpos/model/kyc_model.dart';
import 'package:payrailpos/model/transaction_model.dart';
import 'package:payrailpos/model/user.dart';
import 'package:payrailpos/service/api.dart';
import 'package:payrailpos/widgets/transaction_service.dart';
import 'package:payrailpos/widgets/utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var user = UserModel().obs;
  var onboardingData = KycModel().obs;
  var loading = false.obs;
  var balances = {}.obs;
  var isLoadingBalances = true.obs;
  var isFetchingTransactions = true.obs;
  var transactions = <TransactionModel>[].obs;
  var profileSegment = 'personal'.obs;

  // final signUpCtrl = Get.find(SignupController());

  TextEditingController referralCtrl = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController lga = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController rcNumber = TextEditingController();
  TextEditingController businessName = TextEditingController();
  TextEditingController agentType = TextEditingController();

  var isBalanceVisible = true.obs;

  Future<void> saveBalanceVisibility(bool isVisible) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('balanceVisibility', isVisible);
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
    saveBalanceVisibility(isBalanceVisible.value);
  }

  void getUserInfo() async {
    loading.value = true;
    var response = await Api().get(Endpoints.USER_API);
    loading.value = false;

    if (response.respCode == 0) {
      user.value = UserModel.fromJson(response.data['agent']);
      referralCtrl.text = user.value.referralCode ?? '';
      callFetchBalances();
      callFetchTransactions();
      setFieldsForEdit();
    }
  }

  Future fetchBalances() async {
    var res = await Api().get('api/agent/enquiry/${user.value.id}');

    if (res.respCode == 0) {
      balances.assignAll(res.data);
    }
  }

  Future callFetchBalances() async {
    isLoadingBalances.value = true;
    await fetchBalances();
    isLoadingBalances.value = false;
  }

  Future fetchTransactions() async {
    var date = DateTime.now();
    var dt = date.toString().split(' ')[0].split('-').reversed.join('-');

    var res = await TransactionService().getAgentTransactions(
      user.value.id,
      startDate: dt,
      endDate: dt,
    );
    var list = res.take(3).toList();
    transactions.assignAll(list.map((e) => TransactionModel.fromJson(e)));
  }

  void callFetchTransactions() async {
    isFetchingTransactions.value = true;
    await fetchTransactions();
    isFetchingTransactions.value = false;
  }

  void setFieldsForEdit() {
    phone.text = user.value.phoneNumber;
    email.text = user.value.email ?? '';
    dob.text = user.value.dob ?? 'N/A';
    fullName.text = user.value.firstName + ' ' + user.value.lastName;
    firstName.text = user.value.firstName;
    lastName.text = user.value.lastName;
    gender.text = user.value.gender ?? 'N/A';
    address.text = user.value.address ?? 'N/A';
    city.text = user.value.city ?? 'N/A';
    state.text = user.value.state ?? 'N/A';
    lga.text = user.value.lga ?? 'N/A';
    businessName.text = user.value.businessName ?? 'N/A';
    rcNumber.text = user.value.rcNumber ?? 'N/A';
    agentType.text = user.value.agentType ?? 'N/A';
  }

  // void updateDetails() async {
  //   if (profileSegment.value == 'personal') {
  //     if (!EmailValidator.validate(email.text)) {
  //       Utils.showAlert('email_validation'.tr);
  //       return;
  //     }
  //     if (fullName.text.isEmpty) {
  //       Utils.showAlert('full_name_validation'.tr);
  //       return;
  //     }
  //   } else {
  //     if (businessName.text.isEmpty) {
  //       Utils.showAlert('business_name_validation'.tr);
  //       return;
  //     }
  //   }

  //   var name = fullName.text.split(' ');
  //   var data = {
  //     'email': email.text,
  //     'businessName': businessName.text,
  //     'firstName': name[0],
  //     'lastName': name[1],
  //   };

  //   loading.value = true;
  //   var response = await Api().post(Endpoints.UPDATE_AGENT_API, data);
  //   loading.value = false;

  //   getUserInfo();

  //   if (response.respCode != 0) {
  //     Utils.showAlert(response.respDesc);
  //   } else {
  //     Utils.showAlert(
  //       response.respDesc,
  //       type: AlertType.SUCCESS,
  //       title: 'success'.tr,
  //     );
  //   }
  // }
}
