import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/api.dart';
import '../entities/item.dart';
import '../utils/status_codes.dart';

class ItemService {

  // GET /
  Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse(itemsUrl));

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);

      return (payload['data'] as List)
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }
}
