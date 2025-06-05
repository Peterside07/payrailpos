import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:payrailpos/controller/issue_log_controller.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/issue_log_container.dart';
import 'package:payrailpos/widgets/loaders/app_loader.dart';
import 'package:payrailpos/widgets/log_row_item.dart';
import 'package:payrailpos/widgets/payment_receipt_header.dart';
import 'package:payrailpos/widgets/utils.dart';


class IssueLogDetails extends StatefulWidget {
  final String id;

  const IssueLogDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<IssueLogDetails> createState() => _IssueLogDetailsState();
}

class _IssueLogDetailsState extends State<IssueLogDetails> {
  final logCtrl = Get.put(IssueLogController());

  @override
  void initState() {
    logCtrl.getTicketDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: Utils.appBar(
          context,
          title: logCtrl.loading.value ? '' : logCtrl.ticket.value.uniqueId,
        ),
        body: AppLoader(
          isLoading: logCtrl.loading.value,
          child: SafeArea(
            child: logCtrl.loading.value
                ? Container()
                : ListView(
                    padding: EdgeInsets.all(kPADDING),
                    children: [
                      logCtrl.ticket.value.transaction != null
                          ? PaymentReceiptHeader(
                              amount: logCtrl.ticket.value.transaction!.amount,
                              status: logCtrl.ticket.value.ticketStatus,
                              transactionType:
                                  logCtrl.ticket.value.transaction!.type,
                              statusColor: logCtrl.ticket.value.ticketStatus
                                          .toLowerCase() ==
                                      'open'
                                  ? AppColors.PRIMARY_COLOR
                                  : AppColors.RESOLVED,
                            )
                          : SizedBox(),
                      SizedBox(height: 14),
                      IssueLogContainer(
                        child: Column(
                          children: [
                            LogRowItem(
                              value: 'date_created'.tr,
                              label: DateFormat.yMMMMEEEEd().format(
                                DateTime.parse(
                                  logCtrl.ticket.value.dateCreated,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            LogRowItem(
                              value: 'department'.tr,
                              label: logCtrl.ticket.value.department,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      IssueLogContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'issue_description'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 16),
                            Text(
                              logCtrl.ticket.value.subject,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
