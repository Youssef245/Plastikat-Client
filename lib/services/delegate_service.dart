import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../entities/client.dart';
import '../entities/offer.dart';
import '../entities/delegate.dart';
import '../utils/api.dart';
import '../utils/status_codes.dart';

class DelegateService {
  final String authToken;

  const DelegateService(this.authToken);

  // GET /:id
  Future<Delegate> getDelegateInformation(String delegateId) async {
    final response = await http.get(Uri.parse(delegateByIdUrl(delegateId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        });

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);

      return Delegate.fromJson(payload['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch delegate information');
    }
  }

  // GET /:id/offers
  Future<List<dynamic>> getDelegateOffers(String delegateId) async {
    final response = await http.get(Uri.parse(delegateOffersUrl(delegateId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        });

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);
      return payload['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch delegate offers');
    }
  }

  // PATCH /:id
  Future<void> updateDelegateInformation(String delegateId, Map<String, dynamic> payload) async {
    final response = await http.patch(Uri.parse(delegateByIdUrl(delegateId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode(payload));

    switch (response.statusCode) {
      case noContent:
        log('Delegate information updated');
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
  }
}

class DelegateOffer {
  final String id;
  final Client client;
  final List<ItemOffer> items;
  final String status;

  const DelegateOffer(this.id, this.client, this.items, this.status);

  factory DelegateOffer.fromJson(Map<String, dynamic> json) {
    return DelegateOffer(
        json['_id'] as String,
        Client.fromJson(json['client'] as Map<String, dynamic>),
        (json['items'] as List)
            .map((item) => ItemOffer.fromJson(item as Map<String, dynamic>))
            .toList(),
        json['status'] as String);
  }
}
