# Iki-Mochi

Iki-Mochi adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk pemesanan produk mochi, dengan tujuan mendukung UMKM lokal dalam mengelola pesanan secara digital dan real-time.

Aplikasi ini berfokus pada efisiensi proses pemesanan, transparansi status pesanan bagi pengguna, serta kemudahan pengelolaan pesanan bagi admin/penjual.

---

## Tujuan Aplikasi
- Menyediakan platform pemesanan mochi yang sederhana dan terfokus
- Membantu UMKM lokal dalam mencatat dan mengelola pesanan secara digital
- Memberikan pengalaman pemesanan real-time kepada pelanggan

---

## Fitur Utama

### Fitur Pengguna (User)
- Registrasi dan login akun
- Melihat daftar produk mochi
- Menambahkan produk ke favorit
- Melakukan pemesanan produk
- Memilih metode pembayaran
- Melihat status pesanan secara real-time:
  - Diproses
  - Diantar
  - Selesai
- Melihat lokasi toko menggunakan peta
- Dark mode & light mode

### Fitur Admin
- Role admin terpisah dari user biasa
- Melihat dan mencatat pesanan masuk
- Mengubah status pesanan (real-time)
- Mengelola data pesanan
- Perhitungan dasar jumlah pesanan dan total harga (basic calculator)

### Fitur Tambahan
- Notifikasi perubahan status pesanan
- Pelacakan lokasi toko menggunakan Google Maps API & FlutterMap
- Sinkronisasi data pesanan secara real-time

---

## Tech Stack

- **Flutter** — Framework UI
- **Dart** — Bahasa pemrograman
- **Firebase**
  - Authentication
  - Notifikasi
- **Supabase**
  - Database penyimpanan pesanan
  - Penyimpanan data user per akun
- **Google Maps API**
- **FlutterMap**

> Catatan: Firebase dan Supabase digunakan untuk kebutuhan yang berbeda (autentikasi, notifikasi, dan penyimpanan data), sesuai dengan kebutuhan arsitektur aplikasi.

---

## Arsitektur Singkat
- Aplikasi menggunakan autentikasi berbasis akun
- Setiap pesanan terasosiasi langsung dengan akun user
- Perubahan status pesanan dilakukan oleh admin dan ditampilkan secara real-time ke user
- Data pesanan disimpan dan dikelola melalui Supabase

---

## Status Pengembangan
Aplikasi ini masih dalam tahap pengembangan dan digunakan sebagai project portofolio untuk menunjukkan kemampuan dalam:
- Flutter mobile development
- Integrasi backend (Firebase & Supabase)
- Role-based access
- Real-time data handling
- Integrasi API eksternal (Maps)

---

## Catatan
Project ini dibuat untuk tujuan pembelajaran dan portofolio, serta sebagai simulasi aplikasi pemesanan UMKM skala kecil.
