class WalletTransactionModel {
  final String channel;
  final String purpose;
  final String amount;
  final String dateCreated;
  final String tranType;

  WalletTransactionModel({
    this.channel = '',
    this.purpose = '',
    this.amount = '',
    this.dateCreated = '',
    this.tranType = '',
  });

  factory WalletTransactionModel.fromJson(dynamic json) {
    return WalletTransactionModel(
      channel: json['channel'] ?? '',
      purpose: json['purpose'] ?? '',
      amount: json['amount'] ?? '',
      dateCreated: json['dateCreated'] ?? '',
      tranType: json['tranType'] ?? '',
    );
  }
}
