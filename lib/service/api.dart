import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:payrailpos/global/config.dart';
import 'package:payrailpos/login.dart';
import 'package:payrailpos/model/api_response.dart';
import 'package:payrailpos/service/storage.dart';
import 'package:payrailpos/service/token.dart';

class Api {
  late Dio dio;

  Api() {
    BaseOptions options = BaseOptions(
      baseUrl: AppConfig.BASE_URL,
      connectTimeout: const Duration(seconds: 6000),
    );

    dio = Dio(options);

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
  }

  Future<void> setHeader() async {
    dio.options.headers.addAll({'content-type': 'application/json'});

    var token = TokenService.token;
    if (token.isNotEmpty) {
      dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    }
  }

  Future<ApiResponse> post(String endpoint, dynamic data) async {
    return await _request(endpoint, method: 'post', data: data);
  }

  Future<ApiResponse> put(String endpoint, dynamic data) async {
    return await _request(endpoint, method: 'put', data: data);
  }

  Future<ApiResponse> get(String endpoint) async {
    return await _request(endpoint, method: 'get');
  }

  Future<ApiResponse> delete(String endpoint) async {
    return await _request(endpoint, method: 'delete');
  }
Future<ApiResponse> _request(
  String endpoint, {
  required String method,
  dynamic data,
}) async {
  await setHeader();
  print(AppConfig.BASE_URL + endpoint);
  print(jsonEncode(data));

  try {
    var response = await dio.request(
      endpoint,
      data: data,
      options: Options(method: method),
    );
    print(endpoint);
    print(data);
    debugPrint(response.toString());

    if (response.data.runtimeType == List) {
      return ApiResponse({
        'respCode': 0,
        'respDesc': 'success'.tr,
        'body': response.data,
      }, statusCode: response.statusCode);
    }

    try {
      return ApiResponse(response.data, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse(
        {'respCode': 0, 'respDesc': 'success'.tr, 'data': response.data},
        statusCode: response.statusCode,
      );
    }
  } on DioException catch (err) {
    print('ERROR');
    print(endpoint);
    print(err);
    print(err.response);

    if (err.type == DioExceptionType.connectionTimeout) {
      return ApiResponse(
        {
          'respCode': 99,
          'respDesc': 'Connection timed out',
          'data': {'body': ''}
        },
      );
    }

    if (err.response?.statusCode == 401) {
      Get.offAll(() => Signin());
      StorageService().removeToken();
      return ApiResponse({
        'respCode': 401,
        'respDesc': 'Unauthorized access. Please sign in again.',
        'data': err.response?.data
      });
    }

    if ((err.response?.statusCode ?? 0) >= 400 &&
        err.response?.data.runtimeType == String) {
      return ApiResponse(
        {
          'respCode': err.response?.statusCode,
          'respDesc': err.response?.data.isNotEmpty
              ? err.response?.data
              : 'An error occurred',
          'data': {'body': err.response?.data}
        },
      );
    }

    return ApiResponse({
      'respCode': err.response?.statusCode ?? 99,
      'respDesc': err.response?.data is Map &&
              err.response?.data['respDesc']?.isNotEmpty == true
          ? err.response?.data['respDesc']
          : 'An unexpected error occurred',
      'data': err.response?.data
    });
  }
}
}
