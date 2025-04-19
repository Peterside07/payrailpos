class ApiResponse {
  int? respCode;
  String respDesc = 'Something went wrong';
  dynamic data;

  ApiResponse(dynamic data, {int? statusCode}) {
    int code = 99;
    var dataBody;

    // Handle string responses (e.g., plain error messages)
    if (data.runtimeType == String) {
      this.respDesc = data.isNotEmpty ? data : 'An error occurred';
      return;
    }

    // Prioritize HTTP status code for success
    if (statusCode == 200) {
      code = 0;
    } else {
      // Fallback to body-based logic for other cases
      if (data != null && data is Map) {
        if (data.keys.contains('code') && data['code'] == '200') {
          code = 0;
        } else if (data.keys.contains('token') && data['token'] != null) {
          code = 0; // Handle token-based success (e.g., login)
        }

        if (data.keys.contains('respCode')) {
          code = data['respCode'];
        }

        if (data.keys.contains('body')) {
          print('body');
          dataBody = data['body'];
        }

        if (data.keys.contains('data')) {
          print('data');
          dataBody = data['data'];
        }
      }
    }

    this.respCode = code;
    this.data = dataBody ?? data; // Fallback to full response if no body/data
    this.respDesc = data is Map && data['respDesc']?.isNotEmpty == true
        ? data['respDesc']
        : data is Map && data['message']?.isNotEmpty == true
            ? data['message']
            : code == 0
                ? 'Success'
                : 'Something went wrong';
  }
}