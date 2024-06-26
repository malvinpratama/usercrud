import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../utils/utils.dart';

class NetworkService {
  static final _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  static final Dio _client = Dio(
    BaseOptions(
      baseUrl: Endpoints.kBaseUrl,
      connectTimeout: const Duration(minutes: 1),
      followRedirects: false,
    ),
  )..interceptors.addAll([
      TalkerDioLogger(
        settings: TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
          // Blue http requests logs in console
          requestPen: AnsiPen()..blue(),
          // Green http responses logs in console
          responsePen: AnsiPen()..green(),
          // Error http logs in console
          errorPen: AnsiPen()..red(),
        ),
      ),
    ]);

  static Dio get client => _client;
}
