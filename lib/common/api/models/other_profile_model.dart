class OtherProfileModel {
  final Map<String, dynamic> nearbyProfile;

  OtherProfileModel.fromJson(Map<String, dynamic> json)
      : nearbyProfile = {
          'nickName': json['nickName'],
          'birthDate': json['birthDate'],
          'bio': json['bio'],
        };
}
