part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      name: fields[0] as String?,
      userName: fields[1] as String?,
      phoneNumber: fields[2] as String?,
      dob: fields[3] as String?,
      bio: fields[4] as String?,
      hobbies: (fields[5] as List?)?.cast<String>(),
      imageData: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.dob)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.hobbies)
      ..writeByte(6)
      ..write(obj.imageData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
