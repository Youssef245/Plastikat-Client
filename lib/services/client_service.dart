import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../entities/exchange.dart';
import '../entities/offer.dart';
import '../entities/delegate.dart';
import '../entities/company.dart';
import '../entities/client.dart';
import '../entities/common/device_token.dart';

import '../utils/api.dart';
import '../utils/status_codes.dart';

class ClientService {
  final String? authToken;

  const ClientService(this.authToken);

  // POST /
  Future<void> createClient(Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse(clientsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode({
          'sub': data['id'],
          'name': data['name'],
          'email': data['email'],
          'phone_number': data['phone_number'],
          'birth_date': data['birth_date'],
          'location': {
            'latitude': data['location']['latitude'],
            'longitude': data['location']['longitude']
          },
          'profession': data['profession'],
          'gender': data['gender'],
        }));

    switch (response.statusCode) {
      case created:
        log('Client Account Successfully.');
        break;
      case unauthorized:
        throw Exception('Unauthorized Error: ${jsonDecode(response.body)}');
      case badRequest:
        throw Exception(
            'Failed to create client account: ${jsonDecode(response.body)}');
      case internalServerError:
        throw Exception('Internal Server Error: ${jsonDecode(response.body)}');
    }
  }

  // Sample
  // {
  //   "name": "Omar Abdelaziz",
  //   "address": {
  //     "street": "123 Main St",
  //     "city": "New York",
  //     "state": "NY",
  //     "zip": "10001"
  //   },
  //   "location": {
  //     "type": "Point",
  //     "coordinates": [-74.0060, 40.7128]
  //   },
  //   "phone_number": "123456789"
  // }

  // PATCH /:id
  Future<int> updateClient(
      String clientId, Map<String, dynamic> payload) async {
    final response = await http.patch(Uri.parse(clientByIdUrl(clientId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode(payload));

    switch (response.statusCode) {
      case noContent:
        log('Client updated successfully');
        break;
      case unauthorized:
        throw Exception('Unauthorized Error');
      case badRequest:
        throw Exception('Failed to update client account');
      case internalServerError:
        throw Exception('Internal Server Error');
    }
    return response.statusCode;
  }

  // GET /:id
  Future<Client> getClientInformation(String clientId) async {
    final response = await http.get(Uri.parse(clientByIdUrl(clientId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        });

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);

      return Client.fromJson(payload['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch client information');
    }
  }

  // GET /:id/offers
  Future<List<ClientOffer>> getClientOffers(String clientId) async {
    final response = await http.get(Uri.parse(clientOffersUrl(clientId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        });

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);
      return (payload['data'] as List)
          .map((item) => ClientOffer.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch client offers');
    }
  }

  // PATCH /:id/tokens
  Future<void> updateClientTokens(String clientId, DeviceToken token) async {
    final response = await http.patch(Uri.parse(clientTokensUrl(clientId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode({
          'token': token.token,
          'platform': token.platform,
          'created_at': token.createdAt,
        }));

    switch (response.statusCode) {
      case noContent:
        log('Client tokens updated successfully');
        break;
      case unauthorized:
        throw Exception('Unauthorized Error');
      case badRequest:
        throw Exception('Failed to update client tokens');
      case internalServerError:
        throw Exception('Internal Server Error');
    }
  }

  // GET /:id/exchanges
  Future<List<Exchange>> getClientExchanges(String clientId) async {
    final response = await http.get(Uri.parse(clientExchangesUrl(clientId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        });

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);

      return (payload['data'] as List)
          .map(
              (exchange) => Exchange.fromJson(exchange as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch client exchanges');
  }
}

class ClientOffer {
  final String id;
  final Delegate? delegate;
  final Company? company;

  final int points;
  final List<ItemOffer> items;
  final String status;

  const ClientOffer(this.id, this.delegate, this.company, this.points,
      this.items, this.status);

  factory ClientOffer.fromJson(Map<String, dynamic> json) {
    return ClientOffer(
        json['_id'] as String,
        json['delegate'] != null ? Delegate.fromJson(json['delegate'] as Map<String, dynamic>) : null,
        json['company'] != null ? Company.fromJson(json['company'] as Map<String, dynamic>) : null ,
        json['points'] as int,
        (json['items'] as List)
            .map((item) => ItemOffer.fromJson(item as Map<String, dynamic>))
            .toList(),
        json['status'] as String);
  }
}
