import 'dart:convert';
import 'dart:io';
import 'package:db/common/api/address.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final ip = Platform.isAndroid ? androidEmulatorIP : iosSimulatorIP;
  final dio = Dio();

  Future<String?> readToken() async {
    return await storage.read(key: refreshTokenKeyLS);
  }

  Future<Dio> authDio() async {
    dio.interceptors.clear();

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      // Load AccessToken stored on the device
      final accessToken = await storage.read(key: accessTokenKeyLS);

      // Include AccessToken in the header for each request
      options.headers['Authorization'] = 'Bearer $accessToken';
      return handler.next(options);
    }, onError: (error, handler) async {
      // If authentication error occurs: AccessToken expiration
      if (error.response?.statusCode == 401) {
        // Load AccessToken and RefreshToken stored on the device
        final accessToken = await storage.read(key: accessTokenKeyLS);
        final refreshToken = await storage.read(key: refreshTokenKeyLS);

        // Create a Dio instance for token refresh request
        var refreshDio = Dio();

        refreshDio.interceptors.clear();

        refreshDio.interceptors
            .add(InterceptorsWrapper(onError: (error, handler) async {
          // If another authentication error occurs: RefreshToken expiration
          if (error.response?.statusCode == 401) {
            // Delete automatic login information from the device
            await storage.delete(key: accessTokenKeyLS);
            await storage.delete(key: refreshTokenKeyLS);
            // . . .
            // Show login expiration dialog and navigate to the login page
            // . . .
          }
          return handler.next(error);
        }));

        // Include AccessToken and RefreshToken for token refresh API request
        refreshDio.options.headers['Authorization'] = 'Bearer $accessToken';
        refreshDio.options.headers['Refresh'] = 'Bearer $refreshToken';

        // Make token refresh API request
        final refreshResponse = await refreshDio.get('/token/refresh');

        // Parse newly refreshed AccessToken and RefreshToken from response headers
        final newAccessToken = refreshResponse.headers['Authorization']![0];
        final newRefreshToken = refreshResponse.headers['Refresh']![0];

        // Update stored AccessToken and RefreshToken on the device
        await storage.write(key: accessTokenKeyLS, value: newAccessToken);
        await storage.write(key: refreshTokenKeyLS, value: newRefreshToken);

        // Update AccessToken for the pending API request that couldn't be completed due to expiration
        error.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';

        // Create a copy of the pending API request
        final clonedRequest = await dio.request(error.requestOptions.path,
            options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers),
            data: error.requestOptions.data,
            queryParameters: error.requestOptions.queryParameters);

        // Resend the copied API request
        return handler.resolve(clonedRequest);
      }

      return handler.next(error);
    }));

    return dio;
  }

  /* ===================== token managing ==================== */

  Future<Response?> refreshToken(String refreshToken, String toUrl) async {
    try {
      final Response<dynamic> response = await dio.post(
        ip + toUrl,
        options: Options(
          headers: {
            "authorization": 'Bearer $refreshToken',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  /* ===================== basic login& signin request ==================== */

  // Method to make a POST request with basic authentication
  Future<Response?> request(String userInfo, String toUrl) async {
    try {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String token = stringToBase64.encode(userInfo);

      final Response<dynamic> response = await dio.post(
        ip + toUrl,
        options: Options(
          headers: {
            "authorization": 'Basic $token',
          },
        ),
      );
      debugPrint(response.data);
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  /* ===================== basic ==================== */

  /* ===================== post & get request with token ==================== */
  // Method to make a POST request with Bearer token authentication
  Future<Response?> postWithToken({
    required String accessToken,
    required String toUrl,
    required dynamic data,
  }) async {
    try {
      final Response<dynamic> response = await dio.post(
        ip + toUrl,
        options: Options(
          headers: {
            "authorization": 'Bearer $accessToken',
          },
        ),
        data: data,
      );
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      print('-------------!!!!error!!!!----------------${e.message}');
      return null;
    }
  }

  // Method to make a GET request with Bearer token authentication
  Future<Response?> requestWithToken(String token, String toUrl) async {
    try {
      final Response<dynamic> response = await dio.get(
        ip + toUrl,
        options: Options(
          headers: {
            "authorization": 'Bearer $token',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  Future<Response?> splahsWithToken(String token, String toUrl) async {
    try {
      final Response<dynamic> response = await dio.post(
        ip + toUrl,
        options: Options(
          headers: {
            "authorization": 'Bearer $token',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }
  /* ===================== post & get request with token ==================== */

  /* ============================ error Check =========================== */
  // Method to check login-related errors from the response
  // Method to check response message errors
  Future<String> tokenReponseCheck(Response? response) async {
    if (response == null) {
      return 'error';
    }

    if (response.statusCode == 200) {
      String data = response.data['message'];
      switch (data) {
        case 'login done':
        case 'signup done':
        case 'valid':
        case 'sent':
        case 'edit done':
        case 'userlist':
        case 'gps saved':
          return 'success';
        case 'reissue token':
          return 'reissue token';
        case 'no user':
          return '!NO USER INFORMATION!';
        case 'pw mismatch':
          return '!PASSWORD MISMATCH!';
        case 'duplicated':
          return '!DUPLICATE ACCOUNT!';
        case 'invalid':
          return 'INVALID TOKEN';
        default:
          debugPrint('Response body: ${response.data}');
      }
    } else {
      debugPrint('Request failed with status: ${response.statusCode}');
    }
    return ' ===== !UNEXPECTED ERROR OCCURED! ===== ';
  }
  /* ============================ error Check =========================== */
}
