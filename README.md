# Kantin Bu Sari - Aplikasi Pemesanan Makanan & Minuman Kampus 🍲
> Repositori Pengembangan Tugas: [Kenscenezz/Kantin_Bu_Sari_ZavierMKenna](https://github.com/Kenscenezz/Kantin_Bu_Sari_ZavierMKenna)
> Laboratorium Ilmu Komputer (Maroon Labkom)

---

## 📌 Deskripsi Pengembangan
Aplikasi **"Kantin Bu Sari"** telah dikembangkan secara utuh dan profesional dari starter template awal repositori, dengan mempertahankan struktur navigasi *named routes* (`/`, `/detail`, `/pesan`) serta mengimplementasikan berbagai *interactive widgets* modern Material 3 yang realistis.

---

## 📋 Implementasi Ketentuan Tugas

### 1. Ketentuan 1: Implementasi Minimal 5 Widget Beragam per Halaman

| Halaman & Rute | Daftar Widget Interaktif yang Digunakan | Fungsi & Interaktivitas |
|---|---|---|
| **`MenuListPage`**<br>(Rute: `'/'`) | 1. `TextField` (Search Bar)<br>2. `PageView` + Dots (`PromoBanner`)<br>3. `ChoiceChip` (Kategori makanan)<br>4. `FilterChip` (Status Buka/Tutup)<br>5. `GridView.builder` (Kartu menu)<br>6. `IconButton` (Bookmark favorit)<br>7. `FloatingActionButton.extended` (Keranjang cepat)<br>8. `ActionChip` / `AlertDialog` (Top Up Saldo) | Mencari menu secara live, melihat & klaim kode voucher promo, filter kategori makanan/minuman, beralih status operasional, bookmark menu favorit, dan memantau saldo KantinPay. |
| **`MenuDetailPage`**<br>(Rute: `'/detail'`) | 1. `Slider` (Level pedas 0 s.d. 5)<br>2. `RadioListTile` (Porsi Reguler / Jumbo)<br>3. `CheckboxListTile` (Topping pilihan)<br>4. `TextField` (Catatan koki Bu Sari)<br>5. `IconButton` (+ / - kuantitas)<br>6. `ElevatedButton.icon` (Pesan Sekarang)<br>7. `IconButton` (Favorit AppBar) | Mengatur kepedasan cabai rawit, memilih ukuran porsi (+Rp 3.000), memilih topping tambahan (telur, kerupuk, sambal), menulis pesan kustom koki, mengatur jumlah porsi, serta kalkulasi harga otomatis. |
| **`OrderPage`**<br>(Rute: `'/pesan'`) | 1. `SegmentedButton` (Dine In vs Take Away)<br>2. `TextFormField` (Input nomor meja)<br>3. `Dismissible` (Geser untuk hapus item)<br>4. `TextField` + `ElevatedButton` (Klaim kupon)<br>5. `RadioListTile` (Metode bayar)<br>6. `Stepper` & `LinearProgressIndicator`<br>7. `AlertDialog` (Tiket antrean digital)<br>8. `ElevatedButton.icon` (Kembali ke Daftar Menu) | Memilih tipe makan di tempat/bungkus, menghapus item belanja via gesture geser, klaim diskon voucher `MAHASISWAHEMAT`, memilih metode pembayaran (KantinPay, QRIS, Tunai), serta memantau progres pembuatan makanan. |

---

### 2. Ketentuan 2: Desain Antarmuka (UI) Profesional & Proporsional
- **Palet Warna**: Menggunakan aksen *Deep Orange & Amber* kuliner khas Kantin Bu Sari dengan kontras yang jelas dan proporsional.
- **Kenyamanan Pengguna (UX)**: Feedback visual instan berupa SnackBar mengambang, kalkulasi subtotal + diskon real-time, dan status antrean transparan.
- **Simulasi Live Step**: Disediakan tombol simulasi alur status untuk memudahkan dosen/asisten lab menguji perpindahan status pesanan secara langsung.

---

## 🗂️ Struktur Direktori

```
repo_kantin_busari/
├── lib/
│   ├── main.dart                      # Routing: '/', '/detail', '/pesan' & Tema M3
│   ├── models/
│   │   ├── menu_item.dart             # Model data katalog menu
│   │   ├── cart_item.dart             # Model item pesanan & kustomisasi
│   │   └── order_model.dart           # Model riwayat antrean & status
│   ├── services/
│   │   └── kantin_service.dart        # State Management singleton terpusat
│   ├── widgets/
│   │   └── promo_banner.dart          # Carousel promo swipeable
│   └── pages/
│       ├── menu_list_page.dart        # Halaman 1: Daftar Menu & Beranda
│       ├── menu_detail_page.dart      # Halaman 2: Detail Menu & Kustomisasi
│       └── order_page.dart            # Halaman 3: Keranjang, Checkout & Pelacakan
└── test/
    └── widget_test.dart               # Unit & Widget Test (100% Passed)
```

---

## 🚀 Cara Menjalankan

```bash
cd "repo_kantin_busari"
flutter pub get
flutter run
```
*(Atau uji web/desktop: `flutter run -d chrome` / `flutter run -d windows`)*
