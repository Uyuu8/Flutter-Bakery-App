# 🍰 Flutter Bakery App

Aplikasi toko roti modern berbasis Flutter yang memudahkan pengguna untuk melihat daftar kue, mencari berdasarkan nama, serta melihat detail dan gambar dari setiap produk. Proyek ini terintegrasi dengan Firebase Firestore dan Firebase Storage.

---

## ✨ Fitur Utama

- 🔍 Pencarian kue secara real-time
- 🗂️ Tampilan kategori produk dalam dua mode (grid dan list)
- 🖼️ Gambar produk dari Firebase Storage
- ☁️ Integrasi Firebase Firestore (CRUD data kue)
- 📱 Desain antarmuka modern dan responsif
- 🔧 Manajemen state menggunakan Provider

---

## 🛠️ Teknologi yang Digunakan

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Firebase Firestore](https://firebase.google.com/docs/firestore)
- [Firebase Storage](https://firebase.google.com/docs/storage)
- [Provider](https://pub.dev/packages/provider)
- Local SVG Assets

---

## 📷 Cuplikan Layar

> *Tambahkan screenshot aplikasi kamu di sini (opsional tapi disarankan).*

---

## 🚀 Cara Menjalankan Proyek

### 1. Clone Repositori

```bash
git clone https://github.com/Uyuu8/Flutter-Bakery-App.git
cd Flutter-Bakery-App

### 2. Install Dependency

```bash
flutter pub get

### 3. Tambahkan Konfigurasi Firebase
Buat proyek baru di Firebase Console
Aktifkan Cloud Firestore dan Firebase Storage
Unduh file konfigurasi google-services.json
Letakkan file tersebut di dalam folder:
android/app/
