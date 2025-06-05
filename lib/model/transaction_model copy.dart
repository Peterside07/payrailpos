class TransactionModel {
  final int? id;
  final String? tranRef;
  final String? transactionDate;
  final String status;
  final String type;
  final String? agentName;
  final String? destinationAccount;
  final String? destinationBankCode;
  final String? fromAccount;
  final String? fromAccountBankCode;
  final double? amount;
  final String? customerName;
  final String? customerPhoneNumber;
  final String? description;
  final String? serviceType;

  TransactionModel({
    this.id,
    this.tranRef,
    this.transactionDate,
    this.status = '',
    this.type = '',
    this.agentName,
    this.destinationAccount,
    this.destinationBankCode,
    this.fromAccount,
    this.fromAccountBankCode,
    this.amount,
    this.customerName,
    this.customerPhoneNumber,
    this.description,
    this.serviceType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      tranRef: json['tranRef'],
      transactionDate: json['transactionDate'],
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      agentName: json['agentName'],
      destinationAccount: json['destinationAccount'],
      destinationBankCode: json['destinationBankCode'],
      fromAccount: json['fromAccount'],
      fromAccountBankCode: json['fromAccountBankCode'],
      amount: json['amount'],
      customerName: json['customerName'],
      customerPhoneNumber: json['customerPhoneNumber'],
      description: json['description'],
      serviceType: json['serviceType'],
    );
  }
}
