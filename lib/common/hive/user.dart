import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  late int studentID;

  @HiveField(1)
  late String studentName;

  @HiveField(2)
  late String studentPhoneNum;

  UserData({
    required this.studentID,
    required this.studentName,
    required this.studentPhoneNum,
  });
}
