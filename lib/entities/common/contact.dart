import 'address.dart';

class Contact {
  final Address? address;
  final String? phone;

  const Contact(this.address, this.phone);

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      json['address'] != null ? Address.fromJson(json['address']) : null,
      json['phone'] ? json['phone'] : null,
    );
  }

  toJson() {
    return {
      'address': address?.toJson(),
      'phone': phone,
    };
  }
}
