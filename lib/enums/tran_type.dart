enum TranType {
  accountOpening,
  airtimeRecharge,
  billPayment,
  cableTv,
  dataRecharge,
  deposit,
  electricityRecharge,
  payrailDeposit,
  payrailWithdrawal,
  transfer,
  valueAddedServices,
  withdrawal
}

extension TranTypeExtension on TranType {
  String get value {
    switch (this) {
      case TranType.accountOpening:
        return 'ACCOUNT_OPENING';

      case TranType.airtimeRecharge:
        return 'AIRTIME_RECHARGE';

      case TranType.billPayment:
        return 'BILL_PAYMENT';

      case TranType.cableTv:
        return 'CABLE_TV';

      case TranType.dataRecharge:
        return 'DATA_RECHARGE';

      case TranType.deposit:
        return 'DEPOSIT';

      case TranType.electricityRecharge:
        return 'ElECTRICITY_RECHARGE';

      case TranType.payrailDeposit:
        return 'PAYRAIL_DEPOSIT';

      case TranType.payrailWithdrawal:
        return 'PAYRAIL_WITHDRAWAL';

      case TranType.transfer:
        return 'TRANSFER';

      case TranType.valueAddedServices:
        return 'VALUE_ADDED_SERVICES';

      case TranType.withdrawal:
        return 'WITHDRAWAL';
    }
  }
}
