import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';

enum FilterPeriod { week, month, year }

class TransactionProvider extends ChangeNotifier {
  late Box<TransactionModel> _txBox;
  late Box<BudgetModel> _budgetBox;
  late Box _settingsBox;

  String _userName = 'Pengguna';
  DateTime? _dateOfBirth;
  bool _isFirstRun = true;

  String get userName => _userName;
  DateTime? get dateOfBirth => _dateOfBirth;
  bool get isFirstRun => _isFirstRun;

  FilterPeriod _filterPeriod = FilterPeriod.month;
  DateTime _selectedDate = DateTime.now();

  FilterPeriod get filterPeriod => _filterPeriod;
  DateTime get selectedDate => _selectedDate;

  // ── Cached data ──────────────────────────────────────────────
  List<TransactionModel>? _cachedAllTx;
  List<TransactionModel>? _cachedFilteredTx;
  double? _cachedIncome;
  double? _cachedExpense;
  Map<TransactionCategory, double>? _cachedExpenseByCategory;
  List<Map<String, double>>? _cachedMonthlyChart;
  List<Map<String, double>>? _cachedWeeklyChart;
  Map<TransactionCategory, double>? _cachedSpentByCategory;

  void _invalidateCache() {
    _cachedAllTx = null;
    _cachedFilteredTx = null;
    _cachedIncome = null;
    _cachedExpense = null;
    _cachedExpenseByCategory = null;
    _cachedMonthlyChart = null;
    _cachedWeeklyChart = null;
    _cachedSpentByCategory = null;
  }

  Future<void> init() async {
    _txBox = Hive.box<TransactionModel>('transactions');
    _budgetBox = Hive.box<BudgetModel>('budgets');
    _settingsBox = Hive.box('settings');
    
    _userName = _settingsBox.get('userName', defaultValue: 'User');
    final dobStr = _settingsBox.get('dateOfBirth');
    if (dobStr != null) {
      _dateOfBirth = DateTime.tryParse(dobStr);
    }
    _isFirstRun = _settingsBox.get('isFirstRun', defaultValue: true);
    
    _invalidateCache();
    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    _userName = name;
    await _settingsBox.put('userName', name);
    notifyListeners();
  }

  Future<void> updateDateOfBirth(DateTime date) async {
    _dateOfBirth = date;
    await _settingsBox.put('dateOfBirth', date.toIso8601String());
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isFirstRun = false;
    await _settingsBox.put('isFirstRun', false);
    notifyListeners();
  }

  Future<void> setupProfile({required String name, DateTime? dob}) async {
    _userName = name;
    await _settingsBox.put('userName', name);
    
    if (dob != null) {
      _dateOfBirth = dob;
      await _settingsBox.put('dateOfBirth', dob.toIso8601String());
    }
    
    _isFirstRun = false;
    await _settingsBox.put('isFirstRun', false);
    
    notifyListeners();
  }

  // ── All transactions (sorted once, cached) ──────────────────
  List<TransactionModel> get allTransactions {
    _cachedAllTx ??= _txBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return _cachedAllTx!;
  }

  // ── Filtered transactions (cached) ──────────────────────────
  List<TransactionModel> get filteredTransactions {
    if (_cachedFilteredTx != null) return _cachedFilteredTx!;

    final now = _selectedDate;
    _cachedFilteredTx = allTransactions.where((t) {
      switch (_filterPeriod) {
        case FilterPeriod.week:
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          return t.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
              t.date.isBefore(weekEnd.add(const Duration(days: 1)));
        case FilterPeriod.month:
          return t.date.month == now.month && t.date.year == now.year;
        case FilterPeriod.year:
          return t.date.year == now.year;
      }
    }).toList();
    return _cachedFilteredTx!;
  }

  // ── Income & expense (computed once from cached filtered list)
  double get totalIncome {
    if (_cachedIncome != null) return _cachedIncome!;
    _computeIncomeExpense();
    return _cachedIncome!;
  }

  double get totalExpense {
    if (_cachedExpense != null) return _cachedExpense!;
    _computeIncomeExpense();
    return _cachedExpense!;
  }

  void _computeIncomeExpense() {
    double income = 0;
    double expense = 0;
    for (final t in filteredTransactions) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    _cachedIncome = income;
    _cachedExpense = expense;
  }

  double get balance => totalIncome - totalExpense;

  List<TransactionModel> get recentTransactions =>
      filteredTransactions.take(10).toList();

  // ── Expense by category (single pass, cached) ──────────────
  Map<TransactionCategory, double> get expenseByCategory {
    if (_cachedExpenseByCategory != null) return _cachedExpenseByCategory!;
    final map = <TransactionCategory, double>{};
    for (final t in filteredTransactions) {
      if (t.type == TransactionType.expense) {
        map[t.category] = (map[t.category] ?? 0) + t.amount;
      }
    }
    _cachedExpenseByCategory = map;
    return map;
  }

  // ── Chart data (single pass over all tx, cached) ───────────
  List<Map<String, double>> get monthlyChartData {
    if (_cachedMonthlyChart != null) return _cachedMonthlyChart!;

    final now = DateTime.now();
    // Build month keys for last 6 months
    final months = <int, Map<String, double>>{};
    for (int i = 5; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i, 1);
      final key = m.year * 12 + m.month;
      months[key] = {'income': 0.0, 'expense': 0.0};
    }

    // Single pass over all transactions
    for (final t in _txBox.values) {
      final key = t.date.year * 12 + t.date.month;
      if (months.containsKey(key)) {
        if (t.type == TransactionType.income) {
          months[key]!['income'] = months[key]!['income']! + t.amount;
        } else {
          months[key]!['expense'] = months[key]!['expense']! + t.amount;
        }
      }
    }

    _cachedMonthlyChart = months.values.toList();
    return _cachedMonthlyChart!;
  }

  List<Map<String, double>> get weeklyChartData {
    if (_cachedWeeklyChart != null) return _cachedWeeklyChart!;

    final now = DateTime.now();
    // Build day keys for last 7 days
    final days = <int, Map<String, double>>{};
    final dayOrder = <int>[];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key = day.year * 10000 + day.month * 100 + day.day;
      days[key] = {'income': 0.0, 'expense': 0.0};
      dayOrder.add(key);
    }

    // Single pass over all transactions
    for (final t in _txBox.values) {
      final key = t.date.year * 10000 + t.date.month * 100 + t.date.day;
      if (days.containsKey(key)) {
        if (t.type == TransactionType.income) {
          days[key]!['income'] = days[key]!['income']! + t.amount;
        } else {
          days[key]!['expense'] = days[key]!['expense']! + t.amount;
        }
      }
    }

    _cachedWeeklyChart = dayOrder.map((k) => days[k]!).toList();
    return _cachedWeeklyChart!;
  }

  // ── Budget helpers (cached spent-by-category) ──────────────
  List<BudgetModel> getBudgetsForCurrentMonth() {
    final now = DateTime.now();
    return _budgetBox.values
        .where((b) => b.month == now.month && b.year == now.year)
        .toList();
  }

  double getSpentForCategory(TransactionCategory category) {
    // Build the cache once, then read from it
    _cachedSpentByCategory ??= _buildSpentByCategory();
    return _cachedSpentByCategory![category] ?? 0;
  }

  Map<TransactionCategory, double> _buildSpentByCategory() {
    final now = DateTime.now();
    final map = <TransactionCategory, double>{};
    for (final t in _txBox.values) {
      if (t.type == TransactionType.expense &&
          t.date.month == now.month &&
          t.date.year == now.year) {
        map[t.category] = (map[t.category] ?? 0) + t.amount;
      }
    }
    return map;
  }

  // ── Mutations (invalidate cache before notifying) ──────────
  Future<void> addTransaction({
    required String title,
    required double amount,
    required TransactionType type,
    required TransactionCategory category,
    required DateTime date,
    String? note,
  }) async {
    final tx = TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      type: type,
      category: category,
      date: date,
      note: note,
    );
    await _txBox.put(tx.id, tx);
    _invalidateCache();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await _txBox.delete(id);
    _invalidateCache();
    notifyListeners();
  }

  Future<void> saveBudget({
    required TransactionCategory category,
    required double limitAmount,
  }) async {
    final now = DateTime.now();
    final existing = _budgetBox.values.firstWhere(
      (b) => b.category == category && b.month == now.month && b.year == now.year,
      orElse: () => BudgetModel(
        id: const Uuid().v4(),
        category: category,
        limitAmount: limitAmount,
        month: now.month,
        year: now.year,
      ),
    );
    existing.limitAmount = limitAmount;
    await _budgetBox.put(existing.id, existing);
    _invalidateCache();
    notifyListeners();
  }

  void setFilterPeriod(FilterPeriod period) {
    _filterPeriod = period;
    _invalidateCache();
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _invalidateCache();
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await _txBox.clear();
    await _budgetBox.clear();
    _invalidateCache();
    notifyListeners();
  }
}
