class DeviceToken {
  final String token;
  final String platform;
  final String createdAt;

  const DeviceToken(
    this.token,
    this.platform,
    this.createdAt,
  );

  factory DeviceToken.fromJson(Map<String, dynamic> json) {
    return DeviceToken(
      json['token'],
      json['platform'],
      json['created_at'],
    );
  }

  toJson() {
    return {
      'token': token,
      'platform': platform,
      'created_at': createdAt,
    };
  }
}
