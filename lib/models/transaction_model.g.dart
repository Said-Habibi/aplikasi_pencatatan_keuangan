// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'transaction_model.dart';

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 0;
  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0: return TransactionType.income;
      case 1: return TransactionType.expense;
      default: return TransactionType.expense;
    }
  }
  @override
  void write(BinaryWriter writer, TransactionType obj) {
    writer.writeByte(obj.index);
  }
}

class TransactionCategoryAdapter extends TypeAdapter<TransactionCategory> {
  @override
  final int typeId = 1;
  @override
  TransactionCategory read(BinaryReader reader) {
    final index = reader.readByte();
    return TransactionCategory.values[index.clamp(0, TransactionCategory.values.length - 1)];
  }
  @override
  void write(BinaryWriter writer, TransactionCategory obj) {
    writer.writeByte(obj.index);
  }
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 2;
  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      type: fields[3] as TransactionType,
      category: fields[4] as TransactionCategory,
      date: fields[5] as DateTime,
      note: fields[6] as String?,
    );
  }
  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.amount)
      ..writeByte(3)..write(obj.type)
      ..writeByte(4)..write(obj.category)
      ..writeByte(5)..write(obj.date)
      ..writeByte(6)..write(obj.note);
  }
}
