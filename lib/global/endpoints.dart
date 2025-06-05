// ignore_for_file: constant_identifier_names, non_constant_identifier_names, prefer_function_declarations_over_variables

class Endpoints {
  static const LOGIN = 'agents/login';
  static const SIGN_UP = 'agents/signup';
  static const BANK_API = 'banks/all';
  static const PROCESSPAYMENT = 'api/fidesic/fidesic-purchase';
  static const KeyExchange = 'api/fidesic/session-key';
  static const GENERATE_OTP = 'agents/verify-otp';
  static const VALIDATE_OTP = 'security/otp/validate';
  static const TRANSACTION_API = 'api/transaction/process';
  static const GET_TRANSACTIONS = 'api/transaction/getTransactions';
  static const INTEGRATED_BANKS_API = 'banks/integrated';
  static const FUND_WALLET_API = 'api/wallet/fund';
  static const CHANGE_PIN_API = 'api/agent/pin/change';
  static const NOTIFICATION_API = 'api/notification/';
  static const CASHOUT_API = 'api/wallets/cashout';
  static const COMPLETE_CARD_TRANSACTION = 'api/transaction/completeCard';
  static const WALLET_TRANSFER_API = 'api/wallets/transfer';
  static const ISSUE_LOG_API = 'api/ticket/me';
  static const CREATE_ISSUE_LOG_API = 'api/ticket/add';
  static final ISSUE_LOG_API_DETAILS = (String id) => 'api/ticket/$id/detail';
  static const CABLE_TV_SERVICE_API = 'api/services/cabletv/';
  static const ELECTRICITY_SERVICE_API = 'api/services/electricity/billers';
  static const AGENT_LOANS_API = 'api/loans/active';
  static const LOANS_API = 'api/loans';
  static const LOAN_REQUESTS_API = 'api/loans/requests';
  static const LOAN_HISTORY_API = 'api/loans/history';

  static const CABLE_TV_API = 'api/transaction/cabletv';
  static const ELECTRICITY_API = 'api/transaction/electricunit';
  static const TICKETS_DEPARTMENT_API = 'api/ticket/departments';
  static const TRAN_TYPES_API = 'banks/trantypes';

  static const AGENT_BULK_UPLOAD = 'api/agent/bulkUpload/request';
  static const UPDATE_KYC_API = 'api/agent/kyc/update';
  static const REPORT_API = 'api/reports/count/';
  static const REPORT_FILTER_API = '/api/reports/filter';
  static const KYC_API = 'api/kyc';

  static const CUST_OTP = 'api/customer/otp/generate/';
  static const CUST_ACCOUNT_OTP = 'api/customer/otp/generate/account/';
  static const GET_CUST_BALANCE = 'api/customer/balance';
  static const ACCOUNT_OPENING = 'api/customer/account/create';

  static const NIN_VALIDATION_API = 'security/nin/validate/';
  static const BVN_VALIDATION_API = 'security/bvn/validate/';
  static const PAYRAIL_ENQUIRY = 'banks/payrail/nameEnquiry';

  static const GET_POS_API = 'api/pos';
  static const REQUEST_POS_API = 'api/pos/request';

  static const USER_API = 'security/me';
  static const SECURITY_QUESTION_API = 'api/agent/questions';
  static const GET_SECURITY_QUESTIONS = 'security/security/questions/';
  static const VALIDATE_SECURITY_QUESTION = 'security/validateSecurityQuestion';
  static const CHANGE_PASSWORD_WITH_SECURITY =
      'security/changePasswordWithSecurityQuestion';
  static const UPDATE_AGENT_API = 'api/agent/update';
  static const COMPLETE_SETUP_API = 'security/setup';
  static const CHANGE_PASSWORD = 'api/agent/password/change';
  static const RESET_PASSWORD = 'api/agent/password/reset/';
  static const AIRTIME_BILLERS = 'api/services/airtime/billers';
  static const DATA_BILLERS = 'api/services/data/billers';
  static const SEARCH_TRANSACTION = 'api/transaction/findTransactions';

  static const UPLOAD_RC = 'api/kyc/rc-number';
  static const VALIDATE_RC = 'security/rc-number/validate';

  static const SECURITY_QUESTIONS = 'security/questions/list';
  static const REFERRAL_LIST = 'referrer/list';

  static const ELECTRICITY_VERIFICATION = 'api/services/electricity/';

  static const RESET_PASSCODE = 'api/agent/pin/reset';

  static const TRANSACTION_SUMMARY = 'api/transaction/summary';

  static const VAS_VERIFY_CUSTOMER = 'api/vas/customer/verify';
  static const VAS_CATEGORIES = 'api/vas/categories';
  static final VAS_CATEGORY_PRODUCTS =
      (String categoryId) => 'api/vas/category/$categoryId/products';
  static final VAS_DEAL_HISTORY =
      (String custId) => 'api/vas/customer/$custId/history';
  static final VAS_DEAL_PAYMENTS =
      (String dealId) => 'api/vas/customer/$dealId/payments';
  static const VAS_MAKE_PAYMENT = 'api/vas/deal/complete';
  static const VAS_VALIDATE_CART = 'api/vas/deal/validate';
  static const VAS_PRODUCTS = 'api/vas/products';

  static const UPLOAD_ID_CARD = "api/kyc/id-card";
  static const UPLOAD_SELFIE_IMAGE = "api/kyc/selfie-image";
  static const UPLOAD_CAC = "api/kyc/cac-cert";
  static const UPLOAD_NIN = "api/kyc/nin";
  static const UPLOAD_BVN = "api/kyc/bvn";
  static const UPLOAD_RC_NUMBER = "api/kyc/rc-number";
}
