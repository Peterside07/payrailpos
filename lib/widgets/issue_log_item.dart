import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/model/ticket_model.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/app_divider.dart';
import 'package:payrailpos/widgets/issue_log_details.dart';


class IssueLogItem extends StatelessWidget {
  final TicketItemModel item;

  IssueLogItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () => Get.to(() => IssueLogDetails(id: item.id.toString())),
          dense: true,
          title: Text(
            item.uniqueId,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            item.tranRef != null
                ? '${'for_transaction'.tr} - ${item.tranRef}'
                : item.subject,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.ticketStatus,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: item.ticketStatus.toLowerCase() == 'open'
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.RESOLVED,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_rounded, size: 15),
            ],
          ),
        ),
        AppDivider()
      ],
    );
  }
}
