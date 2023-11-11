import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  late String? name;

  @HiveField(1)
  late String? userName;

  @HiveField(2)
  late String? phoneNumber;

  @HiveField(3)
  late String? dob;

  @HiveField(4)
  late String? bio;

  @HiveField(5)
  late List<String>? hobbies;

  @HiveField(6)
  late String? imageData;

  UserData({
    this.name,
    this.userName,
    this.phoneNumber,
    this.dob,
    this.bio,
    this.hobbies,
    this.imageData,
  });
}
