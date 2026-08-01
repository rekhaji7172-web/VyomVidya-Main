import 'package:hive/hive.dart';

import '../../../core/constants/hive_type_ids.dart';
import '../domain/models/user_progress.dart';

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = HiveTypeIds.userProgress;

  @override
  UserProgress read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };

    return UserProgress(
      totalXp: fields[0] as int? ?? 0,
      currentStreak: fields[1] as int? ?? 0,
      bestStreak: fields[2] as int? ?? 0,
      lastActiveDate: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalXp)
      ..writeByte(1)
      ..write(obj.currentStreak)
      ..writeByte(2)
      ..write(obj.bestStreak)
      ..writeByte(3)
      ..write(obj.lastActiveDate);
  }
}
