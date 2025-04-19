import 'dart:io';

const kPADDING = 20.0;

const CARD_SERVICE_NAME = 'Paystack';
const POS_SERVICE_NAME = "Pos";
const ACCOUNT_PAYMENT = 'Account';
const CASH_PAYMENT = 'Cash';

final NAIRA = Platform.isAndroid ? 'N' : '₦';

final EMAIL_SUPPORT = 'support@payrail.co';
final FACEBOOK_LINK = 'https://web.facebook.com/Payrail-Agency-111184701363894';
final TWITTER_LINK = 'https://twitter.com/payrailagency';
final INSTAGRAM_LINK = 'https://www.instagram.com/payrail.agency/';
final LINKEDIN_LINK = 'https://www.linkedin.com/in/payrail-agency-b2a418225';

final TERMS_LINK = 'https://payrail.co/agency/terms';
final PRIVACY_LINK = 'https://payrail.co/agency/privacy';

final RATE_STORE = Platform.isAndroid ? 'Play Store' : 'App Store';

final KYC_INCOMPLETE = 'KYC verification pending';

abstract class StoreLinks {
  static final String ios =
      'https://apps.apple.com/app/payrail-agency/id1588794187';
  static final String android =
      'https://play.google.com/store/apps/details?id=com.angala.payrail';
  static final String web = 'https://payrail.co/agency';

  static final message = '''
Pay bills, access loans, get health insurance.

Android - $android

iOS - $ios
''';
}
