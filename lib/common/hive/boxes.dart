import 'package:db/common/hive/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  static Box<UserData> getUserData() => Hive.box<UserData>('student');
}
