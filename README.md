# 💸 Dompetku

> *"Poor"* — Ryo Yamada, mungkin lagi lihat saldo rekening gue

<p align="center">
  <img src="assets/icon/ryo.jpeg" width="200" alt="Ikon Aplikasi — Ryo scan 'Poor'"/>
</p>

**Dompetku** adalah aplikasi pencatatan keuangan pribadi premium yang dibuat dengan Flutter. Aplikasi ini membantu kamu mencatat pemasukan, pengeluaran, mengatur anggaran, dan memvisualisasikan pengeluaranmu — semua data tersimpan secara lokal di perangkat dengan sentuhan UI modern ala iOS.

## 🤔 Kenapa Gue Bikin Ini

Simpel: **Gue boros.**

Setiap bulan gue selalu bingung, "Duit gue kemana aja sih?" Ternyata, langkah pertama biar nggak bokek adalah mencatat pengeluaran. Jadi gue bikin aplikasi ini buat menghakimi diri sendiri setiap kali beli barang yang nggak perlu.

Ikon aplikasinya Ryo Yamada lagi scan "Poor" karena jujur? Itu mood-nya. Itu vibes-nya. Kalau kamu relate, aplikasi ini buat kamu.

---

## 🎸 Tema Warna & Animasi Bocchi the Rock!

Seluruh palet warna terinspirasi dari 4 anggota **Kessoku Band** dari anime *Bocchi the Rock!*:

| Karakter | Warna | Hex | Digunakan Untuk |
31: 
|----------|-------|-----|-----------------|
| 🩷 **Hitori "Bocchi" Gotoh** | Pink Lembut | `#E8839B` | Warna utama, tombol, elemen aktif |
| 💛 **Nijika Ijichi** | Emas Hangat | `#F5C542` | Pemasukan (duit masuk = energi positif!) |
| 💙 **Ryo Yamada** | Biru Sejuk | `#4A6FA5` | Warna sekunder, background (kalem kayak Ryo) |
| ❤️ **Ikuyo Kita** | Merah Cerah | `#E5534B` | Pengeluaran, peringatan, hapus (semangat belanja) |

### 🏝️ Fitur Premium: Dynamic Island Header
Aplikasi ini memiliki animasi header kustom yang terinspirasi dari **Dynamic Island**. Saat kamu melakukan scroll:
- Header utama akan memudar secara halus.
- Saldo kamu akan bertransformasi menjadi sebuah **kapsul silinder** kecil yang bergerak ke atas dan "membungkus" area kamera *punch-hole* HP kamu.
- Warna header bertransisi secara organik dari Pink Bocchi ke Biru Navy Ryo.

---

## ✨ Fitur Utama

### 📊 Dashboard Canggih
- **Dynamic Island Header**: Animasi saldo yang mengikuti gerakan scroll.
- **Weather Reminder**: Informasi cuaca real-time untuk mengingatkan kamu bawa payung (biar nggak beli payung baru terus!).
- **Automatic GPS**: Deteksi lokasi otomatis untuk data cuaca yang akurat berdasarkan posisimu saat ini.
- **Entrance Animations**: Efek muncul berurutan (*staggered animations*) untuk setiap bagian dashboard.

### 💰 Manajemen Transaksi
- Tambah transaksi pemasukan & pengeluaran dengan 10 kategori ikonik.
- Visualisasi grafik batang yang interaktif (Mingguan/Bulanan/Tahunan).
- Riwayat transaksi lengkap dengan pencarian & filter.

### 📋 Manajemen Anggaran
- Atur anggaran bulanan per kategori.
- Progress bar visual untuk memantau pengeluaran vs. anggaran.
- Peringatan cerdas saat anggaran hampir habis.

### 🔔 Notifikasi Pintar
- ⚠️ Peringatan anggaran (≥80% & terlampaui).
- 📈 Deteksi lonjakan pengeluaran mendadak.
- 💸 Peringatan defisit (Pengeluaran > Pemasukan).
- 🎉 Pencapaian tabungan.

---

## 🛠️ Teknologi

| Teknologi | Fungsi |
|-----------|--------|
| **Flutter** | Framework UI utama |
| **Hive** | Database NoSQL lokal super cepat |
| **Provider** | State management yang efisien |
| **Geolocator** | Integrasi GPS untuk deteksi lokasi otomatis |
| **wttr.in API** | Data cuaca tanpa perlu API Key |
| **fl_chart** | Grafik visualisasi keuangan |

---

## 🚀 Cara Memulai

### Prasyarat
- Flutter SDK (≥3.11.5)
- Android Studio / VS Code
- Koneksi Internet (untuk data cuaca)
- Izin Lokasi (untuk sinkronisasi cuaca otomatis)

### Instalasi

```bash
# Clone repository
git clone https://github.com/Said-Habibi/aplikasi_pencatatan_keuangan.git

# Masuk ke folder proyek
cd aplikasi_pencatatan_keuangan

# Install dependensi
flutter pub get

# Jalankan aplikasi
flutter run
```

---

## 📁 Struktur Proyek

```
lib/
├── main.dart                  # Entry point & navigasi
├── models/                    # Data models (Transaction, Budget, Weather)
├── providers/                 # State management (Logic & GPS)
├── screens/                   # Halaman (Dashboard, Settings, dll)
├── widgets/                   # Komponen UI (Header, Chart, Tiles)
└── utils/                     # Utility (Theme, Weather, Notifications)
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
