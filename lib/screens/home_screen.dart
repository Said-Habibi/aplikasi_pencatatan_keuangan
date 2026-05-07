import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_theme.dart';
import '../utils/notification_helper.dart';
import '../widgets/filter_chip_row.dart';
import '../widgets/summary_header.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/income_expense_chart.dart';
import 'notification_screen.dart';
import 'all_transactions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 230,
                pinned: true,
                backgroundColor: AppTheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: SummaryHeader(provider: provider),
                ),
                title: const Text('Dompetku', style: TextStyle(color: Colors.white)),
                actions: [
                  _buildNotificationBell(context, provider),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilterChipRow(provider: provider),
                      const SizedBox(height: 16),
                      IncomeExpenseChart(provider: provider),
                      const SizedBox(height: 20),
                      _buildRecentTransactions(context, provider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, TransactionProvider provider) {
    final txs = provider.recentTransactions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Transaksi Terakhir',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AllTransactionsScreen()),
              ),
              child: Text('Lihat Semua', style: TextStyle(color: AppTheme.primaryLight, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (txs.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text('Belum ada transaksi',
                  style: TextStyle(color: Colors.white.withOpacity(0.4))),
            ),
          )
        else
          ...txs.map((tx) => TransactionTile(
                transaction: tx,
                onDelete: () => provider.deleteTransaction(tx.id),
              )),
      ],
    );
  }

  Widget _buildNotificationBell(BuildContext context, TransactionProvider provider) {
    final notifications = NotificationHelper.generate(provider);
    final count = notifications.length;
    return IconButton(
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count', style: const TextStyle(fontSize: 10)),
        backgroundColor: AppTheme.expense,
        child: const Icon(Icons.notifications_outlined, color: Colors.white),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationScreen()),
      ),
    );
  }
}
