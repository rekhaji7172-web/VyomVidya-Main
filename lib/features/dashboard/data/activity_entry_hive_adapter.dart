import 'package:hive/hive.dart';

import '../../../core/constants/hive_type_ids.dart';
import '../domain/models/activity_entry.dart';
import '../domain/models/activity_type.dart';

class ActivityEntryAdapter extends TypeAdapter<ActivityEntry> {
  @override
  final int typeId = HiveTypeIds.activityEntry;

  @override
  ActivityEntry read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };

    return ActivityEntry(
      type: ActivityType.values.byName(fields[0] as String),
      title: fields[1] as String,
      timestamp: fields[2] as DateTime,
      xpDelta: fields[3] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type.name)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.xpDelta);
  }
}
