import 'partner.dart';
import 'common/reward.dart';


class Exchange {
  final String id;
  final Partner partner;
  final int amount;
  final DateTime date;
  final Reward reward;

  const Exchange(this.id, this.partner, this.amount, this.date, this.reward);

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      json['_id'],
      Partner.fromJson(json['partner']),
      json['amount'],
      DateTime.parse(json['date']),
      Reward.fromJson(json['reward']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'partner': partner.toJson(),
      'amount': amount,
      'date': date.toIso8601String(),
      'reward': reward.toJson(),
    };
  }
}