import 'package:flutter/material.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_theme.dart';

class FilterChipRow extends StatelessWidget {
  final TransactionProvider provider;
  const FilterChipRow({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(context, 'Minggu', FilterPeriod.week),
        const SizedBox(width: 8),
        _chip(context, 'Bulan', FilterPeriod.month),
        const SizedBox(width: 8),
        _chip(context, 'Tahun', FilterPeriod.year),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, FilterPeriod period) {
    final active = provider.filterPeriod == period;
    return GestureDetector(
      onTap: () => provider.setFilterPeriod(period),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
