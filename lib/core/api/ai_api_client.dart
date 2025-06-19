import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mtxo_lab/core/api/api_endpoints.dart';
import 'package:mtxo_lab/core/utils/logger.dart';
import 'package:mtxo_lab/shared/constants/app_constants.dart';
import '../errors/app_error.dart';
import '../utils/network_info.dart';

class AIApiClient {
  final Dio _dio = Dio();
  final NetworkInfo _networkInfo;
  final ConsoleAppLogger _logger = ConsoleAppLogger();
  CancelToken? cancelToken;

  AIApiClient(this._networkInfo) {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    _dio.options.baseUrl = ApiEndpoints.aiBaseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 30000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'X-API-Key': Constants.AIToken
    };

    // Add logging interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('API Request: ${options.method} ${options.path}');
        _logger.d('AI Headers: ${options.headers}');
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

  Stream<dynamic> requestStream(String endpoint,
      {String method = 'GET', Map<String, dynamic>? body}) async* {
    if (!await _networkInfo.isConnected) {
      _logger.e('No internet connection');
      throw AppError('No internet connection');
    }

    try {
      _logger
          .d('Sending streaming $method request to $endpoint with body: $body');

      // Configure options for streaming
      final options = Options(
        method: method,
        responseType: ResponseType.stream, // Important for streaming
      );
      cancelToken = CancelToken();
      // Make the request with streaming enabled
      final response = await _dio.request<ResponseBody>(
        endpoint,
        data: body,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.data == null) {
        throw AppError('No stream data received');
      }

      // Get the stream from the response
      final responseStream = response.data!.stream;
      String buffer = '';
      // Process the stream data
      int i = 0;
      await for (final chunk in responseStream) {
        try {
          ConsoleAppLogger().d("Count 123 ${i++}");
          // Convert the chunk to a string if needed
          // Note: For different streaming formats, you might need different conversion logic
          //final decodedChunk = _decodeChunk(chunk);
          // Convert the chunk to a string and add to buffer
          String stringData = String.fromCharCodes(chunk);
          buffer += stringData;

          // Process complete lines in the buffer
          List<String> lines = buffer.split('\n');
          // The last element might be incomplete, so we keep it in the buffer
          buffer = lines.removeLast();

          // Process and yield each complete line
          for (var line in lines) {
            if (line.isNotEmpty) {
              dynamic decodedLine = _decodeLine(line);
              yield decodedLine;
            }
          }
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

  stopStreaming() {
    cancelToken?.cancel("User Stopped the chat");
  }

  Stream<dynamic> diffyrequestStream(String endpoint,
      {String method = 'GET',
      Map<String, dynamic>? body,
      String apikey = ""}) async* {
    if (!await _networkInfo.isConnected) {
      _logger.e('No internet connection');
      throw AppError('No internet connection');
    }

    try {
      Dio diifydio = Dio();
      _logger
          .d('Sending streaming $method request to $endpoint with body: $body');
      Map<String, dynamic> header = {};
      header.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apikey'
      });

      // Configure options for streaming
      final options = Options(
        method: method,
        responseType: ResponseType.stream, // Important for streaming
        headers: header,
      );

      // Make the request with streaming enabled
      diifydio.options.baseUrl = ApiEndpoints.DiffybaseUrl;
      final response = await diifydio.request<ResponseBody>(
        endpoint,
        data: body,
        options: options,
      );

      if (response.data == null) {
        throw AppError('No stream data received');
      }

      // Get the stream from the response
      final responseStream = response.data!.stream;
      String buffer = '';
      // Process the stream data
      await for (final chunk in responseStream) {
        try {
          // Convert the chunk to a string if needed
          // Note: For different streaming formats, you might need different conversion logic
          // final decodedChunk = _decodeChunk(chunk);
          // _logger.d('Received stream chunk: $decodedChunk');
          // yield decodedChunk;
          String stringData = String.fromCharCodes(chunk);
          buffer += stringData;

          // Process complete lines in the buffer
          List<String> lines = buffer.split('\n');
          // The last element might be incomplete, so we keep it in the buffer
          buffer = lines.removeLast();

          // Process and yield each complete line
          for (var line in lines) {
            if (line.isNotEmpty) {
              dynamic decodedLine = _decodeLine(line);
              yield decodedLine;
            }
          }
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

  // Helper method to decode a single line
  dynamic _decodeLine(String line) {
    line = line.trim();
    try {
      if (line.startsWith('{') || line.startsWith('[')) {
        return jsonDecode(line);
      }
      return line;
    } catch (e) {
      ConsoleAppLogger().d("Error decoding line: $e");
      return line;
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
        throw AppError(
            'Server error: ${e.response?.statusCode ?? "Unknown"} && ${e.response?.data ?? "Unknown"}');
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
