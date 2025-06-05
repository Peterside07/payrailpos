class KycModel {
  String? cacBase64Img;
  String cacKycStatus;
  String? selfieBase64Img;
  String selfieKycStatus;
  String? idCardBase64Img;
  String idCardKycStatus;
  String? bvn;
  String bvnKycStatus;
  String? nin;
  String ninKycStatus;
  String? rcNumber;
  String rcNumberKycStatus;

  KycModel({
    this.cacBase64Img,
    this.cacKycStatus = 'PENDING_UPLOAD',
    this.selfieBase64Img,
    this.selfieKycStatus = 'PENDING_UPLOAD',
    this.idCardBase64Img,
    this.idCardKycStatus = 'PENDING_UPLOAD',
    this.bvn,
    this.bvnKycStatus = 'PENDING_UPLOAD',
    this.nin,
    this.ninKycStatus = 'PENDING_UPLOAD',
    this.rcNumber,
    this.rcNumberKycStatus = 'PENDING_UPLOAD',
  });

  factory KycModel.fromJson(dynamic json) {
    return KycModel(
      cacBase64Img: json['cacBase64Img'],
      cacKycStatus: json['cacKycStatus'] ?? 'PENDING_UPLOAD',
      selfieBase64Img: json['selfieBase64Img'],
      selfieKycStatus: json['selfieKycStatus'] ?? 'PENDING_UPLOAD',
      idCardBase64Img: json['idCardBase64Img'],
      idCardKycStatus: json['idCardKycStatus'] ?? 'PENDING_UPLOAD',
      bvn: json['bvn'],
      bvnKycStatus: json['bvnKycStatus'] ?? 'PENDING_UPLOAD',
      nin: json['nin'],
      ninKycStatus: json['ninKycStatus'] ?? 'PENDING_UPLOAD',
      rcNumber: json['rcNumber'],
      rcNumberKycStatus: json['rcNumberKycStatus'] ?? 'PENDING_UPLOAD',
    );
  }
}

class UpdateKycModel {
  final String title;
  final String value;
  final String endpoint;

  UpdateKycModel({
    required this.title,
    required this.value,
    required this.endpoint,
  });
}
