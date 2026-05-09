import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'Profil',
            children: [
              _buildTile(
                icon: Icons.person_outline,
                iconColor: AppTheme.primary,
                title: 'Nama Pengguna',
                subtitle: provider.userName,
                onTap: () => _showEditNameDialog(context),
              ),
              _buildTile(
                icon: Icons.cake_outlined,
                iconColor: Colors.pinkAccent,
                title: 'Tanggal Lahir',
                subtitle: provider.dateOfBirth == null
                    ? 'Belum diatur'
                    : DateFormat('dd MMMM yyyy', 'id_ID').format(provider.dateOfBirth!),
                onTap: () => _showEditBirthDateDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Data',
            children: [
              _buildTile(
                icon: Icons.delete_sweep_outlined,
                iconColor: AppTheme.expense,
                title: 'Hapus Semua Data',
                subtitle: 'Menghapus semua transaksi dan anggaran',
                onTap: () => _showClearDataDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Cuaca',
            children: [
              SwitchListTile.adaptive(
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.cloud_outlined, color: Colors.blue, size: 20),
                ),
                title: const Text('Pengingat Cuaca', style: TextStyle(color: Colors.white, fontSize: 15)),
                subtitle: const Text('Tampilkan info cuaca di dashboard', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                value: provider.weatherEnabled,
                onChanged: (val) => provider.updateWeatherSettings(enabled: val),
                activeColor: AppTheme.primary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              if (provider.weatherEnabled) ...[
                SwitchListTile.adaptive(
                  secondary: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: provider.isDetectingLocation 
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green),
                          )
                        : const Icon(Icons.my_location, color: Colors.green, size: 20),
                  ),
                  title: const Text('Lokasi Otomatis', style: TextStyle(color: Colors.white, fontSize: 15)),
                  subtitle: const Text('Gunakan GPS untuk deteksi lokasi', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                  value: provider.autoLocationEnabled,
                  onChanged: (val) => provider.updateWeatherSettings(autoLocation: val),
                  activeColor: AppTheme.primary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                if (!provider.autoLocationEnabled)
                  _buildTile(
                    icon: Icons.location_on_outlined,
                    iconColor: Colors.orange,
                    title: 'Lokasi',
                    subtitle: provider.weatherLocation,
                    onTap: () => _showEditLocationDialog(context),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: 'Tentang Aplikasi',
            children: [
              _buildTile(
                icon: Icons.info_outline,
                iconColor: AppTheme.primaryLight,
                title: 'Dompetku',
                subtitle: 'Versi 2.0.0',
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade700, size: 20),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final provider = context.read<TransactionProvider>();
    final controller = TextEditingController(text: provider.userName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Ubah Nama', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Masukkan nama kamu',
            hintStyle: const TextStyle(color: Color(0xFF6B7280)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.5))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primary)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.updateUserName(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditBirthDateDialog(BuildContext context) async {
    final provider = context.read<TransactionProvider>();
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: AppTheme.cardBg,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      provider.updateDateOfBirth(picked);
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Semua Data?',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Semua transaksi dan anggaran akan dihapus secara permanen. Tindakan ini tidak bisa dibatalkan.',
          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.expense,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await ctx.read<TransactionProvider>().clearAllData();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Semua data berhasil dihapus'),
                    backgroundColor: AppTheme.surface,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.account_balance_wallet, color: AppTheme.primary, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('Dompetku', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Aplikasi pencatatan keuangan pribadi.\n\nVersi 2.0.0\nDibuat dengan Flutter.',
          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showEditLocationDialog(BuildContext context) {
    final provider = context.read<TransactionProvider>();
    final controller = TextEditingController(text: provider.weatherLocation);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Ubah Lokasi', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Masukkan nama kota (misal: Jakarta)',
            hintStyle: const TextStyle(color: Color(0xFF6B7280)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.5))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primary)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.updateWeatherSettings(location: controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
