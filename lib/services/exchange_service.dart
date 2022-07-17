import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../utils/status_codes.dart';
import '../utils/api.dart';

class ExchangeService {
  final String authToken;

  const ExchangeService(this.authToken);

  // POST /
  Future<int> exchangeReward(Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(exchangesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode(payload));

    switch (response.statusCode) {
      case created:
        log('Exchange created');
        break;
      case unauthorized:
        throw Exception('Unauthorized');
      case badRequest:
        throw Exception('Bad request');
      case internalServerError:
        throw Exception('Internal server error');
      default:
        throw Exception('Unknown error');
    }
  return response.statusCode;
  }
}
