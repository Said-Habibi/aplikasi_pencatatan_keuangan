# 💸 Dompetku

> *"Poor"* — Ryo Yamada, mungkin lagi lihat saldo rekening gue

<p align="center">
  <img src="assets/icon/ryo.jpeg" width="200" alt="Ikon Aplikasi — Ryo scan 'Poor'"/>
</p>

**Dompetku** adalah aplikasi pencatatan keuangan pribadi yang dibuat dengan Flutter. Aplikasi ini membantu kamu mencatat pemasukan, pengeluaran, mengatur anggaran, dan memvisualisasikan pengeluaranmu — semua data tersimpan secara lokal di perangkat.

## 🤔 Kenapa Gue Bikin Ini

Simpel: **Gue boros.**

Setiap bulan gue selalu bingung, "Duit gue kemana aja sih?" Ternyata, langkah pertama biar nggak bokek adalah mencatat pengeluaran. Jadi gue bikin aplikasi ini buat menghakimi diri sendiri setiap kali beli barang yang nggak perlu.

Ikon aplikasinya Ryo Yamada lagi scan "Poor" karena jujur? Itu mood-nya. Itu vibes-nya. Kalau kamu relate, aplikasi ini buat kamu.

---

## 🎸 Tema Warna Bocchi the Rock!

Seluruh palet warna terinspirasi dari 4 anggota **Kessoku Band** dari anime *Bocchi the Rock!*:

| Karakter | Warna | Hex | Digunakan Untuk |
|----------|-------|-----|-----------------|
| 🩷 **Hitori "Bocchi" Gotoh** | Pink Lembut | `#E8839B` | Warna utama, tombol, elemen aktif |
| 💛 **Nijika Ijichi** | Emas Hangat | `#F5C542` | Pemasukan (duit masuk = energi positif, kayak Nijika!) |
| 💙 **Ryo Yamada** | Biru Sejuk | `#4A6FA5` | Warna sekunder, background (dalam dan misterius, kayak Ryo) |
| ❤️ **Ikuyo Kita** | Merah Cerah | `#E5534B` | Pengeluaran, peringatan, hapus (semangat belanja, very Kita) |

### Kenapa mapping-nya gini?

- **Bocchi = Warna Utama** — Dia karakter utama, dan pink adalah warna paling hangat buat menyambut pengguna
- **Nijika = Pemasukan** — Matahari-nya band, sama kayak pemasukan yang jadi matahari-nya dompet kamu
- **Ryo = Background** — Kalem, adem, dan selalu di belakang layar menopang semuanya (dan dia juga bokek, cocok buat background aplikasi keuangan)
- **Kita = Pengeluaran** — Energi belanja yang membara. Setiap pembelian panas kayak semangat Kita

Gradien header mengalir dari **pink Bocchi → biru Ryo**, merepresentasikan perjalanan dari optimisme ke realita saat kamu cek saldo.

Background gelap menggunakan warna biru navy yang terinspirasi dari warna rambut Ryo, karena jujur aja — ngecek keuangan itu paling enak dilakukan di gelap biar nggak ada yang lihat kamu nangis.

---

## ✨ Fitur

### 📊 Dashboard
- Ringkasan saldo bulanan (Pemasukan & Pengeluaran)
- Grafik keuangan dengan tampilan mingguan/bulanan/tahunan
- Daftar transaksi terbaru

### 💰 Manajemen Transaksi
- Tambah transaksi pemasukan & pengeluaran
- 10 kategori dengan ikon emoji (Makanan, Transport, Belanja, dll.)
- Geser untuk menghapus transaksi
- Riwayat transaksi lengkap dengan pencarian & filter

### 📋 Manajemen Anggaran
- Atur anggaran bulanan per kategori
- Progress bar visual yang menunjukkan pengeluaran vs. anggaran
- Peringatan saat mendekati atau melebihi batas anggaran

### 🔔 Notifikasi Pintar
- ⚠️ Peringatan anggaran (≥80% terpakai)
- 🚫 Peringatan anggaran terlampaui
- 📈 Deteksi lonjakan pengeluaran (vs. bulan lalu)
- 🎉 Pencapaian tabungan
- 💸 Peringatan defisit saat pengeluaran > pemasukan
- Badge counter di ikon lonceng notifikasi

### ⚙️ Pengaturan
- Hapus semua data
- Info aplikasi

---

## 🛠️ Teknologi

| Teknologi | Fungsi |
|-----------|--------|
| **Flutter** | Framework UI cross-platform |
| **Hive** | Database NoSQL lokal (offline-first) |
| **Provider** | State management |
| **fl_chart** | Grafik batang untuk visualisasi keuangan |
| **intl** | Format tanggal & mata uang Indonesia |

---

## 🚀 Cara Memulai

### Prasyarat
- Flutter SDK (≥3.11.5)
- Android Studio / VS Code
- Perangkat Android atau iOS / emulator

### Instalasi

```bash
# Clone repository
git clone https://github.com/your-username/aplikasi_pencatatan_keuangan.git

# Masuk ke folder proyek
cd aplikasi_pencatatan_keuangan

# Install dependensi
flutter pub get

# Jalankan aplikasi
flutter run
```

### Build APK Release

```bash
flutter build apk --release
```

File APK ada di `build/app/outputs/flutter-apk/app-release.apk`

---

## 📱 Cara Penggunaan

### 1. Menambah Transaksi
- Ketuk tombol **+** di bagian bawah tengah layar
- Pilih **Pemasukan** atau **Pengeluaran**
- Isi judul, nominal, kategori, dan tanggal
- Ketuk **Simpan** untuk menyimpan

### 2. Melihat Semua Transaksi
- Di halaman utama, ketuk **Lihat Semua** di sebelah "Transaksi Terakhir"
- Gunakan kolom pencarian untuk mencari transaksi tertentu
- Filter berdasarkan tipe: Semua / Masuk / Keluar
- Geser ke kiri pada transaksi untuk menghapusnya

### 3. Mengatur Anggaran
- Buka tab **Budget** (ikon dompet di navigasi bawah)
- Ketuk **Tambah Anggaran** untuk menambah anggaran per kategori
- Atur batas bulanan kamu
- Aplikasi akan melacak pengeluaranmu dan menampilkan progress bar

### 4. Melihat Notifikasi
- Ketuk **ikon 🔔 lonceng** di halaman utama
- Lihat peringatan pintar tentang kebiasaan pengeluaranmu
- Badge merah menunjukkan jumlah notifikasi aktif

### 5. Mengubah Periode Waktu
- Di halaman utama, ketuk **Minggu**, **Bulan**, atau **Tahun** untuk mengubah tampilan grafik dan data

---

## 📁 Struktur Proyek

```
lib/
├── main.dart                  # Entry point & navigasi utama
├── models/
│   ├── transaction_model.dart # Model data transaksi & kategori
│   └── budget_model.dart      # Model data anggaran
├── providers/
│   └── transaction_provider.dart # State management dengan caching
├── screens/
│   ├── home_screen.dart       # Dashboard utama
│   ├── statistics_screen.dart # Grafik & breakdown kategori
│   ├── budget_screen.dart     # Manajemen anggaran
│   ├── settings_screen.dart   # Pengaturan aplikasi
│   ├── notification_screen.dart # Notifikasi pintar
│   ├── all_transactions_screen.dart # Riwayat transaksi lengkap
│   └── add_transaction_screen.dart  # Tambah transaksi baru
├── widgets/
│   ├── summary_header.dart    # Header ringkasan saldo
│   ├── filter_chip_row.dart   # Chip filter periode waktu
│   ├── income_expense_chart.dart # Widget grafik batang
│   └── transaction_tile.dart  # Item daftar transaksi
└── utils/
    ├── app_theme.dart         # Tema warna Bocchi the Rock!
    ├── currency_formatter.dart # Format Rupiah
    └── notification_helper.dart # Generator notifikasi pintar
```

---

## 📄 Lisensi

Proyek ini bersifat open source dan tersedia untuk penggunaan pribadi.

---

<p align="center">
  <i>Dibuat dengan 💸 kesakitan dan 🎸 energi Bocchi the Rock!</i>
  <br/>
  <i>Karena kalau Ryo bisa bertahan hidup sambil bokek, kita juga bisa.</i>
</p>
