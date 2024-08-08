//Dio Interceptor

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../model/network_response.dart';
import '../presentation/auth/auth_controller/login_controller.dart';


class NetworkCaller {
  static final dio.Dio _dio = dio.Dio(dio.BaseOptions(
    baseUrl: 'https://probashiapp.eitrobotics.com/api',
    connectTimeout: const Duration(milliseconds: 2000),
    receiveTimeout: const Duration(milliseconds: 2000),
    headers: _defaultHeaders(),
  ))
    // ..interceptors.add(dio.InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     log('${options.method} Request: ${options.uri}');
    //     log('Request Headers: ${options.headers}');
    //     log('Request Data: ${options.data}');
    //     return handler.next(options);
    //   },
    //   onResponse: (response, handler) {
    //     _logResponse(response);
    //     if (response.statusCode == 401) {
    //       _handleUnauthorized();
    //     }
    //     return handler.next(response);
    //   },
    //   onError: (dio.DioError e, handler) {
    //     // log('Error: $e');
    //     return handler.next(e);
    //   },
    // ))
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      filter: (options, args) {
        if (options.path.contains('/posts')) {
          return false;
        }
        return !args.isResponse || !args.hasUint8ListData;
      },
    ));
  /// GET request method
  static Future<NetworkResponse> getRequest(String path, {Map<String, dynamic>? queryParams,        bool isLogin = false,
  }) async {
    try {
      final dio.Response response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: dio.Options(headers: _defaultHeaders(isLogin: isLogin)),

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
      final dio.Response response = await _dio.post(
        path,
        data: jsonEncode(body ?? {}),
        options: dio.Options(headers: _defaultHeaders(isLogin: isLogin)),
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
      final dio.Response response = await _dio.put(
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
      final dio.Response response = await _dio.patch(
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
      final dio.Response response = await _dio.delete(
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

  static void _logResponse(dio.Response response) {
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



