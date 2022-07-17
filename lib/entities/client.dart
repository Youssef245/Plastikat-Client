import '../entities/common/location.dart';

class Client {
  final String id;
  final String name;
  final String email;
  final int points;
  final String? phone;
  final String? birthDate;
  final String? gender;
  final String? profession;
  final Location? location;

  const Client(this.id, this.name, this.email, this.points, this.phone,
      this.birthDate, this.gender, this.profession, this.location);

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        json['_id'],
        json['name'],
        json['email'],
        json['points'],
        json['phone'],
        json['birth_date'],
        json['gender'],
        json['profession'],
        json['location']);
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'points': points,
      'phone': phone,
      'birth_date': birthDate,
      'gender': gender,
      'profession': profession,
      'location': location?.toJson(),
    };
  }
}
