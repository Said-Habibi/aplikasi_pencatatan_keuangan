import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
enum TransactionCategory {
  @HiveField(0)
  makanan,
  @HiveField(1)
  transport,
  @HiveField(2)
  belanja,
  @HiveField(3)
  hiburan,
  @HiveField(4)
  tagihan,
  @HiveField(5)
  kesehatan,
  @HiveField(6)
  pendidikan,
  @HiveField(7)
  gaji,
  @HiveField(8)
  bisnis,
  @HiveField(9)
  lainnya,
}

extension CategoryExt on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.makanan:    return 'Makanan';
      case TransactionCategory.transport:  return 'Transport';
      case TransactionCategory.belanja:    return 'Belanja';
      case TransactionCategory.hiburan:    return 'Hiburan';
      case TransactionCategory.tagihan:    return 'Tagihan';
      case TransactionCategory.kesehatan:  return 'Kesehatan';
      case TransactionCategory.pendidikan: return 'Pendidikan';
      case TransactionCategory.gaji:       return 'Gaji';
      case TransactionCategory.bisnis:     return 'Bisnis';
      case TransactionCategory.lainnya:    return 'Lainnya';
    }
  }

  String get icon {
    switch (this) {
      case TransactionCategory.makanan:    return '🍜';
      case TransactionCategory.transport:  return '🚗';
      case TransactionCategory.belanja:    return '🛒';
      case TransactionCategory.hiburan:    return '🎮';
      case TransactionCategory.tagihan:    return '📄';
      case TransactionCategory.kesehatan:  return '💊';
      case TransactionCategory.pendidikan: return '📚';
      case TransactionCategory.gaji:       return '💼';
      case TransactionCategory.bisnis:     return '📊';
      case TransactionCategory.lainnya:    return '💰';
    }
  }
}

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late TransactionType type;

  @HiveField(4)
  late TransactionCategory category;

  @HiveField(5)
  late DateTime date;

  @HiveField(6)
  String? note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });
}
