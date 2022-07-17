import 'delegate.dart';
import 'company.dart';
import 'item.dart';

class ItemOffer extends Item {
  final int quantity;

  const ItemOffer(
      // ignore: no_leading_underscores_for_local_identifiers
      String _id, String name, String type, int points, this.quantity)
      : super(_id, name, type, points);

 /* factory ItemOffer.fromJson(Map<String, dynamic> json) {
    return ItemOffer(
      json['_id'],
      json['name'],
      json['type'],
      json['points'],
      json['quantity'],
    );
  }*/
  factory ItemOffer.fromJson(Map<String, dynamic> json) {
    return ItemOffer(
      json['details']['_id'],
      json['details']['name'],
      json['details']['type'],
      json['details']['points'],
      json['quantity'],
    );
  }
}

class Offer {
  final String id;
  final Delegate? delegate;
  final Company? company;
  final int points;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ItemOffer> items;
  final String status;

  const Offer(this.id, this.delegate, this.company, this.points,
      this.createdAt, this.updatedAt, this.items, this.status);

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      json['_id'],
      json['delegate'] != null ? Delegate.fromJson(json['delegate']) : null,
      json['company'] != null ? Company.fromJson(json['company']) : null,
      json['points'],
      DateTime.parse(json['created_at']),
      json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      List<ItemOffer>.from(json['items'].map((x) => ItemOffer.fromJson(x))),
      json['status'],
    );
  }

  toJson() {
    return {
      '_id': id,
      'delegate': delegate?.toJson(),
      'company': company?.toJson(),
      'points': points,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'items': items.map((x) => x.toJson()).toList(),
      'status': status,
    };
  }
}
