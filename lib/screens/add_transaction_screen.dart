import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  TransactionType _type = TransactionType.expense;
  TransactionCategory _category = TransactionCategory.makanan;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTypeToggle(),
            const SizedBox(height: 20),
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildCategoryPicker(),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildNoteField(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _typeBtn(TransactionType.expense, 'Pengeluaran', AppTheme.expense)),
          Expanded(child: _typeBtn(TransactionType.income, 'Pemasukan', AppTheme.income)),
        ],
      ),
    );
  }

  Widget _typeBtn(TransactionType type, String label, Color color) {
    final active = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: active ? Border.all(color: color, width: 1.5) : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? color : Colors.grey,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    final color = _type == TransactionType.income ? AppTheme.income : AppTheme.expense;
    return TextFormField(
      controller: _amountCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
      decoration: InputDecoration(
        labelText: 'Jumlah (Rp)',
        prefixText: 'Rp ',
        prefixStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Masukkan jumlah';
        if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Jumlah tidak valid';
        return null;
      },
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleCtrl,
      decoration: const InputDecoration(
        labelText: 'Keterangan',
        hintText: 'Contoh: Makan siang, Gaji bulan ini...',
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Masukkan keterangan' : null,
    );
  }

  Widget _buildCategoryPicker() {
    final expenseCategories = [
      TransactionCategory.makanan, TransactionCategory.transport,
      TransactionCategory.belanja, TransactionCategory.hiburan,
      TransactionCategory.tagihan, TransactionCategory.kesehatan,
      TransactionCategory.pendidikan, TransactionCategory.lainnya,
    ];
    final incomeCategories = [
      TransactionCategory.gaji, TransactionCategory.bisnis, TransactionCategory.lainnya,
    ];
    final categories = _type == TransactionType.expense ? expenseCategories : incomeCategories;

    if (!categories.contains(_category)) {
      _category = categories.first;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kategori', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final active = _category == cat;
            return GestureDetector(
              onTap: () => setState(() => _category = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppTheme.primary.withOpacity(0.3) : AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? AppTheme.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cat.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(cat.label,
                        style: TextStyle(
                          color: active ? AppTheme.primaryLight : const Color(0xFF9CA3AF),
                          fontSize: 13,
                        )),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(primary: AppTheme.primary),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _date = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppTheme.primaryLight, size: 20),
            const SizedBox(width: 12),
            Text(
              '${_date.day}/${_date.month}/${_date.year}',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteCtrl,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Catatan (opsional)',
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _save,
        child: const Text('Simpan Transaksi'),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<TransactionProvider>();
    await provider.addTransaction(
      title: _titleCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text),
      type: _type,
      category: _category,
      date: _date,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );
    if (mounted) Navigator.pop(context);
  }
}
