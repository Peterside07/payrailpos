import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payrailpos/controller/transaction_controller.dart';
import 'package:payrailpos/global/constants.dart';
import 'package:payrailpos/screen/home/transactions/empty_widget.dart';
import 'package:payrailpos/screen/home/transactions/transaction_card.dart';
import 'package:payrailpos/screen/home/transactions/transaction_separator.dart';
import 'package:payrailpos/theme/colors.dart';
import 'package:payrailpos/widgets/inputs/app_input.dart';
import 'package:payrailpos/widgets/loaders/app_loader.dart';

import '../../../model/transaction_model.dart';


class TransactionScreen extends StatefulWidget {
  final Function(TransactionModel)? onSelect;

  TransactionScreen({Key? key, this.onSelect}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final transactionCtrl = Get.put(TransactionController());

  @override
  void initState() {
    transactionCtrl.callFetchTransactions();
    super.initState();
  }

  DateTime? _startDate;
  DateTime? _endDate;
  bool _showDatePicker = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(),
      body: AppLoader(
            isLoading: transactionCtrl.isLoading.value,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                
                  if (_showDatePicker)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: kPADDING,
                        right: kPADDING,
                        left: kPADDING,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectStartDate(context),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _startDate != null
                                          ? '${_startDate?.day}/${_startDate?.month}/${_startDate?.year}'
                                          : 'Start Date',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const  SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectEndDate(context),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _endDate != null
                                          ? '${_endDate?.day}/${_endDate?.month}/${_endDate?.year}'
                                          : 'End Date',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Get.isDarkMode
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.black,
                            ),
                            onPressed: () {
                              transactionCtrl.fetchFilteredTransactions(
                                  _startDate ?? DateTime.now(),
                                  _endDate ?? DateTime.now());
                            },
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 15),
                  Expanded(
                    child: transactionCtrl.areTransactionsPresent.value
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                transactionCtrl.filteredTransaction.length > 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return TransactionCard(
                                                item: transactionCtrl
                                                    .filteredTransaction[i],
                                                onSelect: widget.onSelect,
                                              );
                                            },
                                            itemCount: transactionCtrl
                                                .filteredTransaction.length,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          transactionCtrl
                                                      .todayTransactions.length >
                                                  0
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TransactionSeparator(
                                                        'today'.tr),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder: (context, i) {
                                                        return TransactionCard(
                                                          item: transactionCtrl
                                                              .todayTransactions[i],
                                                          onSelect:
                                                              widget.onSelect,
                                                        );
                                                      },
                                                      itemCount: transactionCtrl
                                                          .todayTransactions
                                                          .length,
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(),
                                          transactionCtrl.yesterdayTransactions
                                                      .length >
                                                  0
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TransactionSeparator(
                                                        'yesterday'.tr),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder: (context, i) {
                                                        return TransactionCard(
                                                          item: transactionCtrl
                                                              .yesterdayTransactions[i],
                                                          onSelect:
                                                              widget.onSelect,
                                                        );
                                                      },
                                                      itemCount: transactionCtrl
                                                          .yesterdayTransactions
                                                          .length,
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(),
                                          transactionCtrl.transactions.length > 0
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TransactionSeparator(
                                                        'all_transactions'.tr),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder: (context, i) {
                                                        return TransactionCard(
                                                          item: transactionCtrl
                                                              .allTransactions[i],
                                                          onSelect:
                                                              widget.onSelect,
                                                        );
                                                      },
                                                      itemCount: transactionCtrl
                                                          .allTransactions.length,
                                                    ),
                                                  ],
                                                )
                                              : SizedBox()
                                        ],
                                      )
                              ],
                            ),
                          )
                        : EmptyWidget(message: 'no_transactions'.tr),
                  )
                ],
              ),
            ),
          ),
    ));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }
}
