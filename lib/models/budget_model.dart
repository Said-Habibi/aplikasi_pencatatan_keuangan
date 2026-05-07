import 'package:hive/hive.dart';
import 'transaction_model.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 3)
class BudgetModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late TransactionCategory category;

  @HiveField(2)
  late double limitAmount;

  @HiveField(3)
  late int month;

  @HiveField(4)
  late int year;

  BudgetModel({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.month,
    required this.year,
  });
}
