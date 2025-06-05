import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:payrailpos/global/endpoints.dart';
import 'package:payrailpos/model/department_model.dart';
import 'package:payrailpos/model/ticket_model.dart';
import 'package:payrailpos/model/transaction_model.dart';
import 'package:payrailpos/service/api.dart';
import 'package:payrailpos/widgets/utils.dart';

class IssueLogController extends GetxController {
  var issues = <TicketItemModel>[].obs;
  var ticket = TicketDetailsModel().obs;
  var departments = <DepartmentModel>[].obs;
  var tranTypes = [].obs;
  var isFetching = true.obs;
  var isAdding = false.obs;
  var loading = false.obs;
  var transaction = TransactionModel().obs;

  TextEditingController message = TextEditingController(text: '');
  TextEditingController subject = TextEditingController(text: '');
  TextEditingController department = TextEditingController(text: '');

  var image1 = ''.obs;
  var image2 = ''.obs;
  var image3 = ''.obs;
  var issueId = 0.obs;
  var selectedDepartment = DepartmentModel().obs;
  var ticketItem = TicketDetailsModel().obs;

  @override
  onReady() {
    fetchLogs();
    fetchDepartments();
    super.onReady();
  }

  Future fetchLogs() async {
    isFetching.value = true;
    var res = await Api().get(Endpoints.ISSUE_LOG_API);
    isFetching.value = false;

    if (res.respCode == 0) {
      issues.assignAll((res.data as List).map(
        (e) => TicketItemModel.fromJson(e),
      ));
    } else {
      Get.back();
      Utils.showAlert(res.respDesc);
    }
  }

  void fetchDepartments() async {
    isAdding.value = true;
    var res = await Api().get(Endpoints.TICKETS_DEPARTMENT_API);
    isAdding.value = false;

    if (res.respCode == 0) {
      departments.assignAll(
        (res.data as List).map((e) => DepartmentModel.fromJson(e)),
      );
      if (departments.length > 0) {
        selectedDepartment.value = departments[0];
      }
    }
  }

  void setImage(String type, String value) {
    if (type == 'image1') {
      image1.value = value;
    } else if (type == 'image2') {
      image2.value = value;
    } else {
      image3.value = value;
    }
  }

  void validate() {
    if (message.text.isEmpty) {
      Utils.showAlert('empty_description'.tr);
      return;
    }

    postNewIssue();
  }

  void postNewIssue() async {
    var data = {
      "departmentId": selectedDepartment.value.id,
      "message": message.text,
      "subject": message.text,
      "attachment1": image1.value,
      "attachment2": image2.value,
      "attachment3": image3.value,
      'tranRef': transaction.value.tranRef ?? '',
    };

    isAdding.value = true;
    var response = await Api().post(Endpoints.CREATE_ISSUE_LOG_API, data);
    isAdding.value = false;

    if (response.respCode == 0) {
      issueId.value = response.data['ticketId'];
      fetchLogs();
    } else {
      Utils.showAlert(
        response.respDesc.isEmpty ? 'unable_to_report'.tr : response.respDesc,
      );
    }
  }

  void callFetchLogs() async {
    isFetching.value = true;
    fetchDepartments();
    await fetchLogs();
    isFetching.value = false;
  }

  void fetchIssueDetails(int id) async {
    isFetching.value = true;
    var res = await Api().get('api/ticket/$id/detail');
    isFetching.value = false;

    if (res.respCode == 0) {
      ticketItem.value = TicketDetailsModel.fromJson(res.data);
    }
  }

  void getTicketDetails(String id) async {
    loading.value = true;
    var response = await Api().get(Endpoints.ISSUE_LOG_API_DETAILS(id));
    loading.value = false;

    if (response.respCode == 0) {
      ticket.value = TicketDetailsModel.fromJson(response.data);
    } else {
      Get.back();
      Utils.showAlert(response.respDesc);
    }
  }

  void clearFields() {
    image1.value = '';
    image2.value = '';
    image3.value = '';
    message.text = '';
    subject.text = '';
    selectedDepartment.value = DepartmentModel();
    department.text = '';
  }
}
