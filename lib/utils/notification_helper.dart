import 'package:flutter/material.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';
import 'currency_formatter.dart';
import 'weather_helper.dart';

enum NotificationType { warning, danger, success, info }

class NotificationItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final NotificationType type;

  const NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  Color get color {
    switch (type) {
      case NotificationType.warning:
        return const Color(0xFFF59E0B);
      case NotificationType.danger:
        return const Color(0xFFEF4444);
      case NotificationType.success:
        return const Color(0xFF10B981);
      case NotificationType.info:
        return const Color(0xFF3B82F6);
    }
  }
}

class NotificationHelper {
  static List<NotificationItem> generate(TransactionProvider provider) {
    final notifications = <NotificationItem>[];

    // 1. Check budget warnings & exceeded
    final budgets = provider.getBudgetsForCurrentMonth();
    for (final budget in budgets) {
      final spent = provider.getSpentForCategory(budget.category);
      final percentage = budget.limitAmount > 0 ? spent / budget.limitAmount : 0.0;

      if (percentage >= 1.0) {
        final overAmount = spent - budget.limitAmount;
        notifications.add(NotificationItem(
          icon: Icons.warning_amber_rounded,
          title: 'Budget ${budget.category.label} Terlampaui!',
          subtitle:
              'Pengeluaran melebihi anggaran sebesar ${CurrencyFormatter.format(overAmount)}',
          type: NotificationType.danger,
        ));
      } else if (percentage >= 0.8) {
        final pct = (percentage * 100).toStringAsFixed(0);
        notifications.add(NotificationItem(
          icon: Icons.trending_up_rounded,
          title: 'Budget ${budget.category.label} Hampir Habis',
          subtitle:
              'Sudah terpakai $pct% dari anggaran ${CurrencyFormatter.format(budget.limitAmount)}',
          type: NotificationType.warning,
        ));
      }
    }

    // 2. Expense spike compared to last month
    final now = DateTime.now();
    final thisMonthExpense = provider.totalExpense;
    // Calculate last month's expense manually
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    double lastMonthExpense = 0;
    for (final t in provider.allTransactions) {
      if (t.type == TransactionType.expense &&
          t.date.month == lastMonth.month &&
          t.date.year == lastMonth.year) {
        lastMonthExpense += t.amount;
      }
    }

    if (lastMonthExpense > 0 && thisMonthExpense > lastMonthExpense * 1.2) {
      final increase =
          ((thisMonthExpense - lastMonthExpense) / lastMonthExpense * 100)
              .toStringAsFixed(0);
      notifications.add(NotificationItem(
        icon: Icons.show_chart_rounded,
        title: 'Pengeluaran Meningkat $increase%',
        subtitle:
            'Bulan ini ${CurrencyFormatter.format(thisMonthExpense)} vs bulan lalu ${CurrencyFormatter.format(lastMonthExpense)}',
        type: NotificationType.warning,
      ));
    }

    // 3. Positive balance / savings
    final balance = provider.balance;
    if (balance > 0 && provider.totalIncome > 0) {
      final savingsRate =
          (balance / provider.totalIncome * 100).toStringAsFixed(0);
      notifications.add(NotificationItem(
        icon: Icons.savings_rounded,
        title: 'Tabungan Bulan Ini: $savingsRate%',
        subtitle:
            'Kamu berhasil menabung ${CurrencyFormatter.format(balance)} bulan ini. Pertahankan!',
        type: NotificationType.success,
      ));
    }

    // 4. No budgets set
    if (budgets.isEmpty) {
      notifications.add(NotificationItem(
        icon: Icons.playlist_add_rounded,
        title: 'Belum Ada Anggaran',
        subtitle:
            'Atur anggaran bulanan untuk mengontrol pengeluaranmu',
        type: NotificationType.info,
      ));
    }

    // 5. No transactions this month
    if (provider.filteredTransactions.isEmpty) {
      notifications.add(NotificationItem(
        icon: Icons.edit_note_rounded,
        title: 'Belum Ada Transaksi',
        subtitle:
            'Mulai catat pemasukan dan pengeluaranmu bulan ini',
        type: NotificationType.info,
      ));
    }

    // 6. Spending more than income
    if (provider.totalIncome > 0 && provider.totalExpense > provider.totalIncome) {
      notifications.add(NotificationItem(
        icon: Icons.account_balance_wallet_rounded,
        title: 'Pengeluaran Melebihi Pemasukan',
        subtitle:
            'Defisit ${CurrencyFormatter.format(provider.totalExpense - provider.totalIncome)} bulan ini',
        type: NotificationType.danger,
      ));
    }

    // 7. Weather Alert
    if (provider.weatherEnabled && provider.weatherData != null) {
      final weather = provider.weatherData!;
      String title = 'Info Cuaca: ${weather.condition}';
      String subtitle = 'Suhu saat ini di ${provider.weatherLocation} adalah ${weather.tempC.toStringAsFixed(0)}°C.';
      NotificationType type = NotificationType.info;

      if (weather.precipMM > 0) {
        title = 'Siapkan Payung! ☔';
        subtitle = 'Hari ini diprediksi hujan (${weather.precipMM}mm). Jangan lupa bawa payung!';
        type = NotificationType.warning;
      } else if (weather.tempC > 32) {
        title = 'Cuaca Cukup Panas ☀️';
        subtitle = 'Suhu mencapai ${weather.tempC.toStringAsFixed(0)}°C. Jangan lupa minum air!';
      }

      notifications.insert(0, NotificationItem(
        icon: weather.iconData,
        title: title,
        subtitle: subtitle,
        type: type,
      ));
    }

    return notifications;
  }
}
