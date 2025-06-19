// *****************************************************************************************
// * Filename: api_client.dart                                                             *
// * Developer: Deval Joshi                                                                *
// * Date: 11 October 2024                                                                 *                      *
// * Description: This file contains the ApiClient class, responsible for making HTTP      *
// * requests (GET, POST, PUT, DELETE). It includes error handling for network issues,     *
// * server errors, and invalid responses, while logging each request and response.        *
// *****************************************************************************************

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mtxo_lab/core/api/api_endpoints.dart';
import 'package:mtxo_lab/core/utils/logger.dart';
import 'package:mtxo_lab/shared/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/app_error.dart';
import '../utils/network_info.dart';

class ApiClient {
  final Dio _dio;
  final NetworkInfo _networkInfo;
  final ConsoleAppLogger _logger = ConsoleAppLogger();

  ApiClient(this._dio, this._networkInfo) {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? sessionToken = sharedPreferences.getString(Constants.tokenKey);
    String? csrfToken = sharedPreferences.getString(Constants.csrfTokenKey);
    String? _csrfHash = sharedPreferences.getString(Constants.csrfHashKey);
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    //_dio.options.connectTimeout = const Duration(milliseconds: 30000);
    //_dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    if (csrfToken != null) {
      _dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'csrfToken': csrfToken,
        // 'Cookie': '__Host-next-auth.csrf-token=$csrfToken%7C$_csrfHash; ' +
        //     '__Secure-next-auth.callback-url=${Uri.encodeComponent('${ApiEndpoints.baseUrl}/')}; ' +
        //     '__Secure-next-auth.session-token=$sessionToken'
        'Cookie': 'next-auth.csrf-token=$csrfToken%7C$_csrfHash; ' +
            'next-auth.callback-url=${Uri.encodeComponent('${ApiEndpoints.baseUrl}/')}; ' +
            'next-auth.session-token=$sessionToken'
      };
    }

    // Add logging interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('API Request: ${options.method} ${options.path}');
        _logger.d('Headers: ${options.headers}');
        _logger.d('Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.d('Response status: ${response.statusCode}');
        _logger.d('Response data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        _logger.e('Request error: ${e.message}', e);
        _logger.e('Request successful ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  Future<dynamic> request(String endpoint,
      {String method = 'GET', Map<String, dynamic>? body}) async {
    if (!await _networkInfo.isConnected) {
      _logger.e('No internet connection');
      throw AppError('No internet connection');
    }

    try {
      late Response response;

      switch (method) {
        case 'GET':
          _logger.d('Sending GET request to $endpoint');
          response = await _dio.get(endpoint);
          break;
        case 'POST':
          _logger.d('Sending POST request to $endpoint with body: $body');
          response = await _dio.post(endpoint, data: body);
          break;
        case 'PUT':
          _logger.d('Sending PUT request to $endpoint with body: $body');
          response = await _dio.put(endpoint, data: body);
          break;
        case 'DELETE':
          _logger.d('Sending DELETE request to $endpoint');
          response = await _dio.delete(endpoint);
          break;
        default:
          _logger.e('Unsupported HTTP method: $method');
          throw AppError('Unsupported HTTP method');
      }

      _logger.i('Request successful');
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      _logger.e('Request failed', e);
      throw AppError('Request failed: $e');
    }
  }

  Future<dynamic> multipartRequest(
    String endpoint, {
    required Map<String, dynamic> body,
    required Map<String, String> files,
  }) async {
    if (!await _networkInfo.isConnected) {
      _logger.e('No internet connection');
      throw AppError('No internet connection');
    }

    try {
      FormData formData = FormData.fromMap(body);
      for (var entry in files.entries) {
        String fileName = entry.value.split('/').last;
        formData.files.add(MapEntry(
          entry.key,
          await MultipartFile.fromFile(entry.value, filename: fileName),
        ));
      }

      _logger.d('Sending multipart request to $endpoint');
      Response response = await _dio.post(endpoint, data: formData);
      _logger.i('Multipart request successful');
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      _logger.e('Multipart request failed', e);
      throw AppError('Multipart request failed: $e');
    }
  }

  Stream<dynamic> requestStream(String endpoint,
      {String method = 'GET', Map<String, dynamic>? body}) async* {
    if (!await _networkInfo.isConnected) {
      _logger.e('No internet connection');
      throw AppError('No internet connection');
    }

    try {
      _logger.d('Sending streaming $method request to $endpoint');
      Map<String, dynamic> header = {};
      header.addAll({
        'Content-Type': 'application/json',
        'User-Agent': 'insomnia/2023.5.8',
        'X-API-Key':
            'snqDrcRSlooliK1x3qJ7qvh2E/guI7IThPqwptsQVw/eNvTxyJZK1vjhBrQvQ5moeE0mHXA8+6EPzZekA/Za/A=='
      });

      // Configure options for streaming
      final options = Options(
        method: method,
        responseType: ResponseType.stream, // Important for streaming
        headers: header,
      );

      // Make the request with streaming enabled
      final response = await _dio.request<ResponseBody>(
        endpoint,
        data: body,
        options: options,
      );

      if (response.data == null) {
        throw AppError('No stream data received');
      }

      // Get the stream from the response
      final responseStream = response.data!.stream;

      // Process the stream data
      await for (final chunk in responseStream) {
        try {
          // Convert the chunk to a string if needed
          // Note: For different streaming formats, you might need different conversion logic
          final decodedChunk = _decodeChunk(chunk);
          _logger.d('Received stream chunk: $decodedChunk');
          yield decodedChunk;
        } catch (e) {
          _logger.e('Error processing stream chunk', e);
          throw AppError('Error processing stream: $e');
        }
      }
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      _logger.e('Stream request failed', e);
      throw AppError('Stream request failed: $e');
    }
  }

  dynamic _decodeChunk(List<int> chunk) {
    // Convert bytes to string
    final String stringData = String.fromCharCodes(chunk);

    // If the data is JSON, you can parse it
    // This is a basic implementation - modify based on your streaming data format
    try {
      if (stringData.trim().startsWith('{') ||
          stringData.trim().startsWith('[')) {
        return jsonDecode(stringData);
      }
      return stringData;
    } catch (e) {
      // If not valid JSON, return as string
      return stringData;
    }
  }

  void _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _logger.e('Network timeout', e);
        throw AppError('Network timeout. Please try again.');
      case DioExceptionType.connectionError:
        _logger.e('Connection error', e);
        throw AppError(
            'Connection error. Please check your internet connection.');
      case DioExceptionType.badResponse:
        _logger.e('Server error: ${e.response?.statusCode}', e);
        throw AppError('Server error: ${e.response?.statusCode ?? "Unknown"}');
      case DioExceptionType.badCertificate:
        _logger.e('Bad certificate', e);
        throw AppError('Security error. Invalid certificate.');
      case DioExceptionType.cancel:
        _logger.e('Request cancelled', e);
        throw AppError('Request cancelled');
      default:
        _logger.e('Network error', e);
        throw AppError('Network error: ${e.message}');
    }
  }
}

// // *****************************************************************************************
// // * Filename: api_client.dart                                                             *
// // * Developer: Deval Joshi                                                                *
// // * Date: 11 October 2024                                                                 *                      *
// // * Description: This file contains the ApiClient class, responsible for making HTTP      *
// // * requests (GET, POST, PUT, DELETE). It includes error handling for network issues,     *
// // * server errors, and invalid responses, while logging each request and response.        *
// // *****************************************************************************************

// import 'package:http/http.dart' as http;
// import 'package:pucho/core/utils/logger.dart';
// import 'dart:convert';
// import '../errors/app_error.dart';
// import '../utils/network_info.dart';
// import 'api_endpoints.dart';

// class ApiClient {
//   final http.Client _client;
//   final NetworkInfo _networkInfo;
//   final ConsoleAppLogger _logger = ConsoleAppLogger();

//   ApiClient(this._client, this._networkInfo);

//   Future<dynamic> request(String endpoint,
//       {String method = 'GET', Map<String, dynamic>? body}) async {
//     _logger.i('API Request: $method $endpoint');
//     if (!await _networkInfo.isConnected) {
//       _logger.e('No internet connection');
//       throw AppError('No internet connection');
//     }

//     final uri = Uri.parse('${ApiEndpoints.baseUrl}/$endpoint');
//     late http.Response response;

//     try {
//       switch (method) {
//         case 'GET':
//           _logger.d('Sending GET request to $uri');
//           response = await _client.get(uri);
//           break;
//         case 'POST':
//           _logger.d('Sending POST request to $uri with body: $body');
//           response = await _client.post(uri, body: jsonEncode(body));
//           break;
//         case 'PUT':
//           _logger.d('Sending PUT request to $uri with body: $body');
//           response = await _client.put(uri, body: jsonEncode(body));
//           break;
//         case 'DELETE':
//           _logger.d('Sending DELETE request to $uri');
//           response = await _client.delete(uri);
//           break;
//         default:
//           _logger.e('Unsupported HTTP method: $method');
//           throw AppError('Unsupported HTTP method');
//       }

//       _logger.d('Response received with status code: ${response.statusCode}');

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         _logger.i('Request successful');
//         // Validate if the response body is JSON
//         if (_isJson(response.body)) {
//           return jsonDecode(response.body);
//         } else {
//           _logger.e('Unexpected response format (not JSON)');
//           throw AppError('Unexpected response format (not JSON)');
//         }
//       } else {
//         _logger.e('Server error: ${response.statusCode}');
//         throw AppError('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       _logger.e('Request failed', e);
//       throw AppError('Request failed: $e');
//     }
//   }

//   // Helper method to check if the response is valid JSON
//   bool _isJson(String body) {
//     try {
//       jsonDecode(body);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }
// }
