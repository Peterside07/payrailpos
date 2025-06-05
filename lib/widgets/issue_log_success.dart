import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/issue_log_controller.dart';
import 'package:payrailpos/widgets/issue_log_details.dart';

import 'package:payrailpos/widgets/success_widget.dart';

class IssueLogSuccess extends StatelessWidget {
  IssueLogSuccess({Key? key}) : super(key: key);

  final ctrl = Get.put(IssueLogController());

  @override
  Widget build(BuildContext context) {
    return SuccessWidget(
      title: 'report_sent'.tr,
      message: 'report_sent_subtitle'.tr,
      mainBtnText: 'track_issue'.tr,
      secondBtnText: 'go_home'.tr,
      onDone: () {
        Get.to(() => IssueLogDetails(id: ctrl.issueId.value.toString()));
      },
    );
  }
}
