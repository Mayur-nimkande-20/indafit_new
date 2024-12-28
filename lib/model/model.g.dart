// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseCategoriesAdapter extends TypeAdapter<ExerciseCategories> {
  @override
  final int typeId = 1;

  @override
  ExerciseCategories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseCategories(
      name: fields[0] as String,
      shortName: fields[1] as String,
      movements: (fields[2] as List).cast<MovementModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseCategories obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.shortName)
      ..writeByte(2)
      ..write(obj.movements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseCategoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovementModelAdapter extends TypeAdapter<MovementModel> {
  @override
  final int typeId = 2;

  @override
  MovementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovementModel(
      name: fields[0] as String,
      sets: (fields[1] as List).cast<ExerciseModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovementModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.sets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseModelAdapter extends TypeAdapter<ExerciseModel> {
  @override
  final int typeId = 3;

  @override
  ExerciseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseModel(
      set: fields[0] as String,
      reps: fields[1] as String,
      weight: fields[2] as String,
      weightMode: fields[3] as String,
      assistMode: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.set)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.weightMode)
      ..writeByte(4)
      ..write(obj.assistMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 4;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      userName: fields[2] as String,
      passWord: fields[3] as String,
      birthDate: fields[4] as String,
      mobile: fields[5] as String,
      email: fields[6] as String,
      gender: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.passWord)
      ..writeByte(4)
      ..write(obj.birthDate)
      ..writeByte(5)
      ..write(obj.mobile)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.gender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
