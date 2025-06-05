class CurrencyModel {
  final String? name;
  final String? description;
  final bool? defaultCurrency;
  final String? delFlag;

  CurrencyModel({
    this.name = '',
    this.delFlag = '',
    this.description = '',
    this.defaultCurrency,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> data) {
    return CurrencyModel(
      name: data['name'],
      description: data['description'],
      delFlag: data['delFlag'],
      defaultCurrency: data['defaultCurrency'],
    );
  }
}

class CommissionModel {
  final double balance;
  final CurrencyModel? currency;
  final int id;

  CommissionModel({this.currency, this.balance = 0.0, this.id = 0});

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    return CommissionModel(
      balance: json['balance'] ?? 0.0,
      currency: CurrencyModel.fromJson(json['currency']),
      id: json['id'] ?? 0,
    );
  }
}

class WalletModel {
  final int id;
  final String? number;
  final String? type;
  final double? balance;
  final String? delFlag;
  final CurrencyModel? currency;
  final CommissionModel? commission;
  final double creditSum;
  final double debitSum;
  final String? externalAccountNo;
  final String? externalCustomerId;
  final String? externalBankName;
  final String? externalAccountName;

  WalletModel(
      {this.id = 0,
      this.number = '',
      this.type = '',
      this.balance = 0.0,
      this.delFlag = '',
      this.currency,
      this.commission,
      this.creditSum = 0.0,
      this.debitSum = 0.0,
      this.externalAccountNo,
      this.externalCustomerId,
      this.externalBankName,
      this.externalAccountName});

  WalletModel.fromJson(Map<String, dynamic> data)
      : id = data['wallet']['id'] ?? 0,
        externalAccountNo = data['wallet']['externalAccountNo'],
        externalCustomerId = data['wallet']['externalCustomerId'],
        externalBankName = data['wallet']['externalBankName'],
        externalAccountName = data['wallet']['externalAccountName'],
        number = data['wallet']['number'],
        creditSum = data['creditSum'],
        debitSum = data['debitSum'],
        type = data['wallet']['type'],
        balance = data['wallet']['balance'],
        delFlag = data['wallet']['delFlag'],
        currency = CurrencyModel.fromJson(data['wallet']['currency']),
        commission = data['wallet']['commission'] != null
            ? CommissionModel.fromJson(data['wallet']['commission'])
            : null;
}
