import 'common/address.dart';
import 'common/reward.dart';

class Partner {
  // ignore: unused_field
   String id;
   String name;
   String? description;
   List<Reward>? rewards;

   Partner(
      this.id, this.name, this.description, this.rewards);
   Partner.empty(this.id, this.name, this.description);
   Partner.view(this.id, this.name);

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      json['_id'],
      json['name'],
      json['description'],
      json['rewards'] != null
          ? (json['rewards'] as List).map((i) => Reward.fromJson(
            i as Map<String, dynamic>
          )).toList()
          : null,
    );
  }

   factory Partner.fromJson2(Map<String, dynamic> json) {
     return Partner.view(
       json['_id'],
       json['name'],
     );
   }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'rewards': rewards?.map((i) => i.toJson()).toList(),
    };
  }
}
