// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_movie_save.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserMovieSaveAdapter extends TypeAdapter<UserMovieSave> {
  @override
  final int typeId = 2;

  @override
  UserMovieSave read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserMovieSave(
      userId: fields[0] as int,
      movieId: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserMovieSave obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.movieId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserMovieSaveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
