import 'package:hive/hive.dart';

import '../../../core/constants/hive_type_ids.dart';
import '../../../core/sync/sync_status.dart';
import '../domain/models/task.dart';
import '../domain/models/task_category.dart';
import '../domain/models/task_priority.dart';

/// Hand-written [TypeAdapter] for [Task] — no `hive_generator`/`build_runner`
/// dependency. Enums are stored as their `.name` string (stable across enum
/// reordering, unlike `.index`) so adding a new [TaskPriority]/[TaskCategory]
/// value later never corrupts existing on-device data.
///
/// Field write order below is the on-disk schema — see field-number
/// comments. Appending new fields is safe (write them last, read with a
/// default when absent); do not reorder or remove existing field numbers.
class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = HiveTypeIds.task;

  @override
  Task read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };

    return Task(
      localId: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      priority: TaskPriority.values.byName(fields[3] as String),
      category: TaskCategory.values.byName(fields[4] as String),
      dueDate: fields[5] as DateTime?,
      hasDueTime: fields[6] as bool? ?? false,
      isCompleted: fields[7] as bool? ?? false,
      completedAt: fields[8] as DateTime?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      syncStatus: SyncStatus.values.byName(fields[11] as String? ?? SyncStatus.synced.name),
      remoteId: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(13) // field count
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority.name)
      ..writeByte(4)
      ..write(obj.category.name)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.hasDueTime)
      ..writeByte(7)
      ..write(obj.isCompleted)
      ..writeByte(8)
      ..write(obj.completedAt)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.syncStatus.name)
      ..writeByte(12)
      ..write(obj.remoteId);
  }
}
