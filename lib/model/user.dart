class UserModel {
  final String firstName;
  final String lastName;
  final String? email;
  final String phoneNumber;
  final String agentType;
  final bool kycComplete;
  final String? referralCode;
  final String? dob;
  final int id;
  final String? rcNumber;
  final String? gender;
  final String? businessName;
  final String? state;
  final String? lga;
  final String? city;
  final String? address;
  final String classification;
  final bool needSetup;
  final bool selfRegistration;
  final bool changePassword;

  UserModel({
    this.agentType = '',
    this.firstName = '',
    this.lastName = '',
    this.email,
    this.phoneNumber = '',
    this.kycComplete = false,
    this.referralCode,
    this.id = 0,
    this.dob,
    this.rcNumber,
    this.gender,
    this.businessName,
    this.state,
    this.lga,
    this.address,
    this.city,
    this.classification = '',
    this.needSetup = true,
    this.selfRegistration = true,
    this.changePassword = false,
  });

  factory UserModel.fromJson(dynamic data) {
    return UserModel(
      agentType: data['agentType'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'],
      phoneNumber: data['phoneNumber'] ?? '',
      kycComplete: data['kycComplete'] ?? false,
      referralCode: data['referralCode'],
      id: data['id'] ?? 0,
      dob: data['dob'],
      gender: data['gender'],
      rcNumber: data['rcNumber'],
      businessName: data['businessName'],
      state: data['state'],
      lga: data['lga'],
      address: data['address'],
      city: data['city'],
      classification: data['classification'] ?? '',
      needSetup: data['needSetup'] ?? true,
      selfRegistration: data['selfRegistration'] ?? true,
      changePassword: data['changePassword'] ?? false,
    );
  }
}
