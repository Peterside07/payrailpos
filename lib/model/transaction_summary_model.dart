class TransactionSummaryModel {
  double amountToCustomer;
  double fee;
  double originalAmount;
  double amountToDebit;

  TransactionSummaryModel({
    this.amountToCustomer = 0.0,
    this.fee = 0.0,
    this.originalAmount = 0.0,
    this.amountToDebit = 0.0,
  });

  factory TransactionSummaryModel.fromJson(dynamic json) {
    return TransactionSummaryModel(
      amountToCustomer:
          double.tryParse(json['amountToCustomer'].toString()) ?? 0.0,
      fee: double.tryParse(json['fee'].toString()) ?? 0.0,
      originalAmount: double.tryParse(json['originalAmount'].toString()) ?? 0.0,
      amountToDebit: double.tryParse(json['amountToDebit'].toString()) ?? 0.0,
    );
  }
}
