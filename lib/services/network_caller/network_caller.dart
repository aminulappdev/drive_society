import 'dart:convert';
import 'package:dirve_society/app/modules/auth/login/views/login_view.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/services/network_caller/error_message_model.dart';
import 'package:dirve_society/services/network_caller/network_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class NetworkCaller {
  static bool _isHandlingUnauthorized = false;
  final Logger _logger = Logger();

  Future<NetworkResponse> getRequest(String url,
      {Map<String, dynamic>? queryParams, String? accesToken}) async {
    try {
      _logRequest(url);

      if (queryParams != null) {
        url += '?';
        for (String param in queryParams.keys) {
          url += '$param=${queryParams[param]}&';
        }
      }
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'content-type': 'application-json',
      };

      if (accesToken != null) {
        headers['Authorization'] = accesToken;
      }

      var response = await get(uri, headers: headers);
      _logResponse(url, response.statusCode, response.headers, response.body);
      if (response.statusCode == 200) {
        final debugMessage = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: debugMessage,
        );
      } else {
        final errorMessageModel = _parseErrorMessageModel(response.body);
        _handleUnauthorizedResponse(
          response.statusCode,
          errorMessageModel,
          shouldRedirect: accesToken != null,
        );
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessageModel?.message ?? 'Wrong');
      }
    } catch (e) {
      _logResponse(url, -1, null, '', e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  Future<NetworkResponse> patchRequest(String url,
      {Map<String, dynamic>? queryParams,
      String? accesToken,
      Map<String, dynamic>? body}) async {
    try {
      _logRequest(url);

      if (queryParams != null && queryParams.isNotEmpty) {
        url += '?';
        for (String param in queryParams.keys) {
          url += '$param=${queryParams[param]}&';
        }
        url = url.substring(0, url.length - 1); // remove last "&"
      }

      Uri uri = Uri.parse(url);

      // 🔧 Only set content-type if body is not null
      Map<String, String> headers = {};
      if (body != null) {
        headers['content-type'] = 'application/json';
      }

      if (accesToken != null) {
        headers['Authorization'] = accesToken;
      }

      _logRequest(url, headers, body);

      // 🔧 Send encoded body only if body is not null
      final response = await patch(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      _logResponse(url, response.statusCode, response.headers, response.body);

      if (response.statusCode == 200) {
        final debugMessage = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: debugMessage,
        );
      } else {
        final errorMessageModel = _parseErrorMessageModel(response.body);
        _handleUnauthorizedResponse(
          response.statusCode,
          errorMessageModel,
          shouldRedirect: accesToken != null,
        );
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage:
              errorMessageModel?.message ?? 'Something went wrong',
        );
      }
    } catch (e) {
      _logResponse(url, -1, null, '', e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequest(String url, Map<String, dynamic>? body,
      {String? accesToken}) async {
    try {
      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'content-type': 'application/json',
      };

      if (accesToken != null) {
        headers['Authorization'] = accesToken;
      }

      _logRequest(url, headers, body);
      var response = await post(uri, headers: headers, body: jsonEncode(body));
      _logResponse(url, response.statusCode, response.headers, response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final debugMessage = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: debugMessage,
        );
      } else {
        final errorMessageModel = _parseErrorMessageModel(response.body);
        _handleUnauthorizedResponse(
          response.statusCode,
          errorMessageModel,
          shouldRedirect: accesToken != null,
        );
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessageModel?.message ?? 'Wrong');
      }
    } catch (e) {
      _logResponse(url, -1, null, '', e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  Future<NetworkResponse> putRequest(String url, Map<String, dynamic>? body,
      {String? accesToken}) async {
    try {
      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'content-type': 'application/json',
      };

      if (accesToken != null) {
        headers['Authorization'] = accesToken;
      }

      _logRequest(url, headers, body);
      var response = await put(uri, headers: headers, body: jsonEncode(body));
      _logResponse(url, response.statusCode, response.headers, response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final debugMessage = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: debugMessage,
        );
      } else {
        _handleUnauthorizedResponse(
          response.statusCode,
          _parseErrorMessageModel(response.body),
          shouldRedirect: accesToken != null,
        );
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      _logResponse(url, -1, null, '', e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  Future<NetworkResponse> deleteRequest(String url,
      {Map<String, dynamic>? queryParams, String? accesToken}) async {
    try {
      _logRequest(url);

      if (queryParams != null) {
        url += '?';
        for (String param in queryParams.keys) {
          url += '$param=${queryParams[param]}&';
        }
      }
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'content-type': 'application-json',
      };

      if (accesToken != null) {
        headers['Authorization'] = accesToken;
      }

      var response = await delete(uri, headers: headers);
      _logResponse(url, response.statusCode, response.headers, response.body);
      if (response.statusCode == 200) {
        final debugMessage = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: debugMessage,
        );
      } else {
        _handleUnauthorizedResponse(
          response.statusCode,
          _parseErrorMessageModel(response.body),
          shouldRedirect: accesToken != null,
        );
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      _logResponse(url, -1, null, '', e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  Future<NetworkResponse> patchRequestWithToken(String url,
      {Map<String, dynamic>? queryParams,
      String? accesToken,
      Map<String, dynamic>? body}) async {
    try {
      _logRequest(url);

      if (queryParams != null && queryParams.isNotEmpty) {
        url += '?';
        for (String param in queryParams.keys) {
          url += '$param=${queryParams[param]}&';
        }
        url = url.substring(0, url.length - 1); // remove last "&"
      }

      Uri uri = Uri.parse(url);

      // 🔧 Only set content-type if body is not null
      Map<String, String> headers = {};
      if (body != null) {
        headers['content-type'] = 'application/json';
      }

      if (accesToken != null) {
        headers['token'] = accesToken;
      }

      _logRequest(url, headers, body);

      // 🔧 Send encoded body only if body is not null
      final response = await patch(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      _logResponse(url, response.statusCode, response.headers, response.body);

      if (response.statusCode == 200) {
        final debugMessage = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: debugMessage,
        );
      } else {
        final errorMessageModel = _parseErrorMessageModel(response.body);
        _handleUnauthorizedResponse(
          response.statusCode,
          errorMessageModel,
          shouldRedirect: accesToken != null,
        );
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage:
              errorMessageModel?.message ?? 'Something went wrong',
        );
      }
    } catch (e) {
      _logResponse(url, -1, null, '', e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequestWithToken(
      String url, Map<String, dynamic>? body,
      {String? accesToken}) async {
    try {
      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'content-type': 'application/json',
      };

      if (accesToken != null) {
        headers['token'] = accesToken;
      }

      _logRequest(url, headers, body);
      var response = await post(uri, headers: headers, body: jsonEncode(body));
      _logResponse(url, response.statusCode, response.headers, response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final debugMessage = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: debugMessage,
        );
      } else {
        final errorMessageModel = _parseErrorMessageModel(response.body);
        _handleUnauthorizedResponse(
          response.statusCode,
          errorMessageModel,
          shouldRedirect: accesToken != null,
        );
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessageModel?.message ?? 'Wrong');
      }
    } catch (e) {
      _logResponse(url, -1, null, '', e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  void _logRequest(String url,
      [Map<String, dynamic>? headers, Map<String, dynamic>? body]) {
    _logger.i('URL => $url\nHeaders => $headers\nBODY => $body');
  }

  void _logResponse(
      String url, int statusCode, Map<String, String>? headers, String body,
      [String? errorMessage]) {
    if (errorMessage != null) {
      _logger.e('URL => $url\Error Message => $errorMessage');
    } else {
      _logger.i(
          'URL => $url\nHeaders => $headers\nStatusCode => $statusCode \nBODY => $body');
    }
  }

  ErrorMessageModel? _parseErrorMessageModel(String body) {
    try {
      final debugMessage = jsonDecode(body);
      return ErrorMessageModel.fromJson(debugMessage);
    } catch (_) {
      return null;
    }
  }

  void _handleUnauthorizedResponse(
    int statusCode,
    ErrorMessageModel? errorMessageModel,
    {required bool shouldRedirect}
  ) {
    final message = (errorMessageModel?.message ?? '').toLowerCase();
    final isUnauthorized = statusCode == 401 ||
        statusCode == 403 ||
        message.contains('unauthorized access') ||
        message.contains('forbidden');

    if (!shouldRedirect || !isUnauthorized || _isHandlingUnauthorized) {
      return;
    }

    _isHandlingUnauthorized = true;
    Future.microtask(() async {
      await StorageUtil.clearUserSession();
      if (Get.currentRoute != '/login') {
        Get.offAll(() => const LoginView());
      }
      _isHandlingUnauthorized = false;
    });
  }
}
