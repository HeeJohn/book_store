import 'dart:convert';
import 'dart:io';
import 'package:db/common/api/address.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PreApiService {
  final ip = Platform.isAndroid ? androidEmulatorIP : iosSimulatorIP;
  final dio = Dio();

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

      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  // Method to make a POST request with basic authentication
  Future<Response?> requestWithTokenForSplash(
      String accessToken, String toUrl) async {
    try {
      final Response<dynamic> response = await dio.post(
        ip + toUrl,
        options: Options(
          headers: {
            "authorization": 'Bearer $accessToken',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  /* ===================== basic ==================== */

/* ============================ error Check =========================== */
  // Method to check response message errors
  Future<String> reponseMessageCheck(Response? response) async {
    if (response == null) {
      return 'error';
    }

    if (response.statusCode == 200) {
      String data = response.data['message'];
      switch (data) {
        case 'login done':
        case 'signup done':
          return 'success';
        case 'no user':
          return '!NO USER INFORMATION!';
        case 'pw mismatch':
          return '!PASSWORD MISMATCH!';
        case 'duplicated':
          return '!DUPLICATE ACCOUNT!';
        case 'gps saved':
          return 'success';
        default:
          print('=====>>>>> Response body: ${response.data}');
      }
    } else {
      print('=====>>>>> Request failed with status: ${response.statusCode}');
    }
    return ' ===== !UNEXPECTED ERROR OCCURED! ===== ';
  }
/* ============================ error Check =========================== */
}
