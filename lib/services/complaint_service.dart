import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../utils/status_codes.dart';
import '../utils/api.dart';

class ComplaintService {
  final String authToken;

  const ComplaintService(this.authToken);

  Future<int> initiateComplaint(String clientID,Map<String, dynamic> payload) async {
    final response = await http.post(Uri.parse(createComplaint(clientID)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode(payload));

    switch (response.statusCode) {
      case created:
        log('Complaint created');
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
