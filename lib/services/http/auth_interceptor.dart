import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:everfin/modules/auth/services/auth_service.dart';

Future<http.Response> authenticatedGet(
  Uri url, {
  Map<String, String>? headers,
}) async {
  final authToken = await AuthService().getToken();
  if (authToken != null) {
    final newHeaders = <String, String>{
      'Authorization': 'Bearer $authToken',
      ...headers ?? {},
    };
    return http.get(url, headers: newHeaders);
  }
  throw Exception('Token de autenticação não encontrado.');
}

Future<http.Response> authenticatedPost(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  final authToken = await AuthService().getToken();
  if (authToken != null) {
    final newHeaders = <String, String>{
      ...headers ?? {},
      'Authorization': 'Bearer $authToken',
    };
    return http.post(url, headers: newHeaders, body: body, encoding: encoding);
  }
  throw Exception('Token de autenticação não encontrado.');
}
