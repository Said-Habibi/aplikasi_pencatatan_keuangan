import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_theme.dart';
import '../utils/currency_formatter.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anggaran Bulan Ini'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBudgetDialog(context),
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          final budgets = provider.getBudgetsForCurrentMonth();
          if (budgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      size: 64, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  const Text('Belum ada anggaran',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 16)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showAddBudgetDialog(context),
                    child: Text('Tambah Anggaran', style: TextStyle(color: AppTheme.primaryLight)),
                  ),
                ],
              ),
            );
          }

          final totalBudget = budgets.fold<double>(0, (s, b) => s + b.limitAmount);
          final totalSpent = budgets.fold<double>(
              0, (s, b) => s + provider.getSpentForCategory(b.category));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildOverallCard(totalBudget, totalSpent),
              const SizedBox(height: 20),
              ...budgets.map((b) {
                final spent = provider.getSpentForCategory(b.category);
                return _buildBudgetCard(context, provider, b.category, b.limitAmount, spent);
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverallCard(double total, double spent) {
    final pct = total > 0 ? (spent / total).clamp(0.0, 1.0) : 0.0;
    final color = pct > 0.9 ? AppTheme.expense : pct > 0.7 ? const Color(0xFFF59E0B) : AppTheme.income;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Anggaran', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
              Text(CurrencyFormatter.formatCompact(total),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppTheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Terpakai: ${CurrencyFormatter.formatCompact(spent)}',
                  style: TextStyle(color: color, fontSize: 12)),
              Text('Sisa: ${CurrencyFormatter.formatCompact((total - spent).clamp(0, double.infinity))}',
                  style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(BuildContext context, TransactionProvider provider,
      TransactionCategory category, double limit, double spent) {
    final pct = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final isOver = pct >= 1.0;
    final color = isOver ? AppTheme.expense : pct > 0.75 ? const Color(0xFFF59E0B) : AppTheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: isOver ? Border.all(color: AppTheme.expense.withOpacity(0.5)) : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.label,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    Text(
                      '${CurrencyFormatter.formatCompact(spent)} / ${CurrencyFormatter.formatCompact(limit)}',
                      style: TextStyle(
                          color: isOver ? AppTheme.expense : const Color(0xFF9CA3AF), fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (isOver)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.expense.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Melebihi!',
                      style: TextStyle(color: AppTheme.expense, fontSize: 11)),
                ),
              IconButton(
                icon: Icon(Icons.edit_outlined, size: 18, color: Colors.grey.shade600),
                onPressed: () => _showEditBudgetDialog(context, category, limit),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppTheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final categories = [
      TransactionCategory.makanan, TransactionCategory.transport,
      TransactionCategory.belanja, TransactionCategory.hiburan,
      TransactionCategory.tagihan, TransactionCategory.kesehatan,
    ];
    TransactionCategory selected = categories.first;
    final amountCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tambah Anggaran',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              DropdownButtonFormField<TransactionCategory>(
                value: selected,
                dropdownColor: AppTheme.surface,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: categories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text('${c.icon} ${c.label}', style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (v) => setModalState(() => selected = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Batas Anggaran (Rp)',
                  prefixText: 'Rp ',
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (amountCtrl.text.isEmpty) return;
                    await ctx.read<TransactionProvider>().saveBudget(
                      category: selected,
                      limitAmount: double.parse(amountCtrl.text),
                    );
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, TransactionCategory category, double current) {
    final ctrl = TextEditingController(text: current.toInt().toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        title: Text('Edit Anggaran ${category.label}',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(labelText: 'Batas Baru (Rp)', prefixText: 'Rp '),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.isEmpty) return;
              await ctx.read<TransactionProvider>().saveBudget(
                category: category,
                limitAmount: double.parse(ctrl.text),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
