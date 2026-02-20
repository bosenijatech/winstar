import 'dart:convert';

import 'package:powergroupess/utils/netsuite/handlers/request_handler.dart';
import 'package:http/http.dart' as http;

class NetsuiteClient extends http.BaseClient {
  final RequestHandler handler;
  final Duration timeLimit = const Duration(seconds: 15);

  NetsuiteClient({required this.handler});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    var requestHandler = handler.handle(request);
    return requestHandler.send();
  }

  @override
  Future<http.Response> post(Uri url,
      {Object? body, Encoding? encoding, Map<String, String>? headers}) {
    try {
      return super.post(url, body: jsonEncode(body));
    } catch (e) {
      throw Exception(e);
    }
  }
}
