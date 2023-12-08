class Meet {
  final double? latitude, longitude;
  final String? place, time;

  Meet.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        place = json['place'],
        time = json['time'];
}
