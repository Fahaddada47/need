//Dio Interceptor

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../controller/auth_controller/login_controller.dart';
import '../model/network_response.dart';

class NetworkCaller {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com', // Replace with your base URL
    connectTimeout: 5000,
    receiveTimeout: 3000,
    headers: _defaultHeaders(),
  ))..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      log('${options.method} Request: ${options.uri}');
      log('Request Headers: ${options.headers}');
      log('Request Data: ${options.data}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      _logResponse(response);
      if (response.statusCode == 401) {
        _handleUnauthorized();
      }
      return handler.next(response);
    },
    onError: (DioError e, handler) {
      log('Error: $e');
      return handler.next(e);
    },
  ));

  /// GET request method
  static Future<NetworkResponse> getRequest(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode ?? -1,
          data: response.data,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode ?? -1,
          data: null,
          message: response.statusMessage,
        );
      }
    } catch (e) {
      log('Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        data: null,
        message: 'An error occurred',
      );
    }
  }

  /// POST request method
  static Future<NetworkResponse> postRequest(
    String path, {
    Map<String, dynamic>? body,
    bool isLogin = false,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: jsonEncode(body ?? {}),
        options: Options(headers: _defaultHeaders(isLogin: isLogin)),
      );

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode ?? -1,
          data: response.data,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode ?? -1,
          data: response.data,
          message: response.statusMessage,
        );
      }
    } catch (e) {
      log('Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        data: null,
        message: 'An error occurred',
      );
    }
  }

  /// PUT request method
  static Future<NetworkResponse> putRequest(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: jsonEncode(body ?? {}),
      );

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode ?? -1,
          data: response.data,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode ?? -1,
          data: response.data,
          message: response.statusMessage,
        );
      }
    } catch (e) {
      log('Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        data: null,
        message: 'An error occurred',
      );
    }
  }

  /// PATCH request method
  static Future<NetworkResponse> patchRequest(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: jsonEncode(body ?? {}),
      );

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode ?? -1,
          data: response.data,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode ?? -1,
          data: response.data,
          message: response.statusMessage,
        );
      }
    } catch (e) {
      log('Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        data: null,
        message: 'An error occurred',
      );
    }
  }

  /// DELETE request method
  static Future<NetworkResponse> deleteRequest(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: jsonEncode(body ?? {}),
      );

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode ?? -1,
          data: response.data,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode ?? -1,
          data: response.data,
          message: response.statusMessage,
        );
      }
    } catch (e) {
      log('Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        data: null,
        message: 'An error occurred',
      );
    }
  }

  static Map<String, String> _defaultHeaders({bool isLogin = false}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (!isLogin) 'Authorization': 'Bearer ${LoginController.accessToken ?? ''}',
    };
  }

  static void _logResponse(Response response) {
    log('Status Code: ${response.statusCode}');
    log('Response Body: ${response.data}');
  }

  static void _handleUnauthorized() {
    LoginController.clear();
    Get.snackbar('Session Expired', 'Please log in again.');
  }
}

//Network Response 
class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic data;
  final String? message;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.data,
    this.message,
  });

  factory NetworkResponse.fromJson(Map<String, dynamic> json) {
    return NetworkResponse(
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      data: json['data'],
      message: json['message'],
    );
  }
}



