import 'common/contact.dart';

class Company {
  final String id;
  final String name;
 // final String email;
 // final Contact contact;
  
  const Company(this.id,this.name);

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      json['_id'],
      json['name'],
    );
  }

  toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
