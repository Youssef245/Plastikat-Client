class Delegate {
  final String id;
  final String name;
  final double rating;

  const Delegate(this.id,this.name, this.rating,);

  factory Delegate.fromJson(Map<String, dynamic> json) {
    return Delegate(
      json['_id'],
      json['name'],
      json['rating']!= null ? json['gender'] : null,
    );
  }

  // create toJson Method
  toJson() {
    return {
      '_id' : id,
      'name': name,
      'rating': rating,
    };
  }
}
