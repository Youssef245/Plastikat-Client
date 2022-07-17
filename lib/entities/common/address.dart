class Address {
  // ignore: unused_field
  final String? governorate;
  final String? city;
  final String? district;
  final String? street;
  final int? buildingNo;
  final int? flatNo;

  const Address(this.governorate, this.city, this.district, this.street,
      this.buildingNo, this.flatNo);

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      json['governorate'],
      json['city'],
      json['district'],
      json['street'],
      json['building_no'],
      json['flat_no'],
    );
  }

  @override
  String toString()
  {
    return governorate! + " " +city! + " " +governorate! + " " +district! + " " +street! + " " +
        buildingNo.toString() + " " +flatNo.toString() + " ";
  }

  toJson() {
    return {
      'governorate': governorate,
      'city': city,
      'district': district,
      'street': street,
      'building_no': buildingNo,
      'flat_no': flatNo,
    };
  }
}
