class Location {
  final double latitude;
  final double longitude;

  const Location(this.latitude, this.longitude);

  toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}