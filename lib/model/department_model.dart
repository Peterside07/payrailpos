class DepartmentModel {
  final int id;
  final String code;
  final String type;
  final String description;

  DepartmentModel({
    this.id = 0,
    this.code = '',
    this.description = '',
    this.type = '',
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
