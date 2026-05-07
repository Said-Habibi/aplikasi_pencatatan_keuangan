// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'budget_model.dart';

class BudgetModelAdapter extends TypeAdapter<BudgetModel> {
  @override
  final int typeId = 3;
  @override
  BudgetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetModel(
      id: fields[0] as String,
      category: fields[1] as TransactionCategory,
      limitAmount: fields[2] as double,
      month: fields[3] as int,
      year: fields[4] as int,
    );
  }
  @override
  void write(BinaryWriter writer, BudgetModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.category)
      ..writeByte(2)..write(obj.limitAmount)
      ..writeByte(3)..write(obj.month)
      ..writeByte(4)..write(obj.year);
  }
}
