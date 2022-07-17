class Reward {
  final String id;
  final String name;
  final int? points;

  const Reward(this.id, this.name, this.points);

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      json['_id'],
      json['name'],
      json['points'],
    );
  }

  toJson() {
    return {
      '_id': id,
      'name': name,
      'points': points,
    };
  }
}