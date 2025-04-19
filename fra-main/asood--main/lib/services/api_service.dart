import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APIService {
  // API مسیر پایه
  static const String _baseURL = kReleaseMode 
      ? "https://api.asood.ir/api" // مسیر پروداکشن
      : "http://10.0.2.2:8000/api"; // مسیر توسعه (برای امولاتور اندروید)
  
  // ذخیره‌سازی امن برای توکن‌ها
  static const _storage = FlutterSecureStorage();
  
  // هدرهای پیش‌فرض برای تمام درخواست‌ها
  static Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // افزودن توکن احراز هویت در صورت نیاز
    if (requireAuth) {
      final token = await _storage.read(key: 'access_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  // متد عمومی برای استفاده در سراسر اپلیکیشن GET
  static Future<dynamic> get(String endpoint, 
      {Map<String, dynamic>? queryParams, bool requireAuth = true}) async {
    
    try {
      final uri = Uri.parse('$_baseURL/$endpoint')
          .replace(queryParameters: queryParams);
          
      final response = await http.get(
        uri,
        headers: await _getHeaders(requireAuth: requireAuth),
      );
      
      return _handleResponse(response);
    } on SocketException {
      throw 'خطا در اتصال به اینترنت. لطفاً اتصال خود را بررسی کنید.';
    } catch (e) {
      throw 'خطا در برقراری ارتباط با سرور: $e';
    }
  }
  
  // متد POST
  static Future<dynamic> post(String endpoint, dynamic body, 
      {bool requireAuth = true}) async {
    
    try {
      final uri = Uri.parse('$_baseURL/$endpoint');
      final jsonBody = jsonEncode(body);
      
      final response = await http.post(
        uri,
        headers: await _getHeaders(requireAuth: requireAuth),
        body: jsonBody,
      );
      
      return _handleResponse(response);
    } on SocketException {
      throw 'خطا در اتصال به اینترنت. لطفاً اتصال خود را بررسی کنید.';
    } catch (e) {
      throw 'خطا در برقراری ارتباط با سرور: $e';
    }
  }
  
  // متد PUT
  static Future<dynamic> put(String endpoint, dynamic body, 
      {bool requireAuth = true}) async {
    
    try {
      final uri = Uri.parse('$_baseURL/$endpoint');
      final jsonBody = jsonEncode(body);
      
      final response = await http.put(
        uri,
        headers: await _getHeaders(requireAuth: requireAuth),
        body: jsonBody,
      );
      
      return _handleResponse(response);
    } on SocketException {
      throw 'خطا در اتصال به اینترنت. لطفاً اتصال خود را بررسی کنید.';
    } catch (e) {
      throw 'خطا در برقراری ارتباط با سرور: $e';
    }
  }
  
  // متد DELETE
  static Future<dynamic> delete(String endpoint, 
      {bool requireAuth = true}) async {
    
    try {
      final uri = Uri.parse('$_baseURL/$endpoint');
      
      final response = await http.delete(
        uri,
        headers: await _getHeaders(requireAuth: requireAuth),
      );
      
      return _handleResponse(response);
    } on SocketException {
      throw 'خطا در اتصال به اینترنت. لطفاً اتصال خود را بررسی کنید.';
    } catch (e) {
      throw 'خطا در برقراری ارتباط با سرور: $e';
    }
  }
  
  // متد مدیریت پاسخ‌ها
  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        // اگر پاسخ خالی باشد یک مپ خالی برمی‌گرداند
        if (response.body.isEmpty) return {};
        
        // تبدیل پاسخ JSON به Map
        return jsonDecode(utf8.decode(response.bodyBytes));
      
      case 400:
        throw 'درخواست نامعتبر: ${_extractErrorMessage(response)}';
      
      case 401:
        throw 'خطای احراز هویت: لطفاً مجدداً وارد شوید';
      
      case 403:
        throw 'دسترسی غیرمجاز: شما اجازه دسترسی به این بخش را ندارید';
      
      case 404:
        throw 'مسیر مورد نظر یافت نشد';
      
      case 422:
        throw 'خطا در اعتبارسنجی داده‌ها: ${_extractErrorMessage(response)}';
      
      case 500:
      case 502:
      case 503:
        throw 'خطای سرور. لطفاً بعداً تلاش کنید';
      
      default:
        throw 'خطای نامشخص با کد ${response.statusCode}';
    }
  }
  
  // استخراج پیام خطا از پاسخ
  static String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      
      // بر اساس ساختار خطای جنگو
      if (body.containsKey('detail')) {
        return body['detail'];
      } 
      else if (body.containsKey('message')) {
        return body['message'];
      }
      else if (body.containsKey('error')) {
        return body['error'];
      }
      // اگر پیام‌های خطا به صورت آرایه باشند
      else if (body is Map && body.values.isNotEmpty) {
        final firstError = body.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        return firstError.toString();
      }
      
      return 'خطایی رخ داده است';
    } catch (e) {
      return 'خطایی رخ داده است';
    }
  }

  // متد لاگین کاربر
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await post(
        'auth/token/',
        {'username': username, 'password': password},
        requireAuth: false,
      );
      
      // ذخیره توکن‌ها
      await _storage.write(key: 'access_token', value: response['access']);
      await _storage.write(key: 'refresh_token', value: response['refresh']);
      
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  
  // متد رجیستر کاربر
  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await post(
        'users/register/',
        userData,
        requireAuth: false,
      );
      
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  
  // نوسازی توکن
  static Future<bool> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      
      if (refreshToken == null) {
        return false;
      }
      
      final response = await post(
        'auth/token/refresh/',
        {'refresh': refreshToken},
        requireAuth: false,
      );
      
      await _storage.write(key: 'access_token', value: response['access']);
      return true;
    } catch (e) {
      // حذف توکن‌های منقضی شده
      await _storage.deleteAll();
      return false;
    }
  }
  
  // خروج کاربر
  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}