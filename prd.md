# Product Requirement Document (PRD)

## 1. Overview

Courtly adalah aplikasi mobile untuk melakukan booking lapangan olahraga secara online.

Aplikasi memungkinkan pengguna melihat daftar venue, mengecek ketersediaan lapangan, memilih jadwal, dan melakukan reservasi tanpa harus menghubungi admin secara manual.

Versi MVP berfokus pada booking lapangan padel dengan dukungan multi-tenant, sehingga satu aplikasi dapat digunakan oleh beberapa venue berbeda.

---

# 2. Problem Statement

Saat ini banyak venue olahraga masih menerima booking melalui WhatsApp.

Permasalahan yang sering terjadi:

* Jadwal bentrok (double booking)
* Sulit melihat slot yang tersedia
* Admin harus membalas chat satu per satu
* Riwayat booking tidak terdokumentasi dengan baik

Courtly membantu menyederhanakan proses reservasi dengan sistem booking digital.

---

# 3. Target User

## Customer

Orang yang ingin menyewa lapangan.

Karakteristik:

* Usia 18–40 tahun
* Aktif menggunakan smartphone
* Ingin melihat jadwal kosong secara cepat

## Tenant Admin

Pemilik atau pengelola venue.

Karakteristik:

* Mengelola satu atau lebih lapangan
* Memerlukan sistem pencatatan booking

---

# 4. Goals

## Business Goal

* Mempermudah proses reservasi lapangan
* Mengurangi double booking
* Menyediakan dashboard booking untuk admin

## Product Goal

* User dapat melakukan booking dalam kurang dari 2 menit
* User dapat melihat slot tersedia secara real-time
* Admin dapat mengelola booking dengan mudah

---

# 5. User Flow

Customer

Home
↓
Pilih Venue
↓
Pilih Lapangan
↓
Pilih Tanggal
↓
Pilih Jam
↓
Isi Data Pemesan
↓
Booking Berhasil
↓
Kode Booking

Admin

Login
↓
Dashboard
↓
Lihat Booking
↓
Konfirmasi Pembayaran
↓
Booking Selesai

---

# 6. Features MVP

## F1. Venue List

User dapat melihat daftar venue.

Informasi:

* Nama venue
* Lokasi
* Foto
* Jumlah lapangan

---

## F2. Venue Detail

Menampilkan:

* Deskripsi
* Daftar lapangan
* Harga per jam
* Jam operasional

---

## F3. Court Availability

User dapat melihat slot yang tersedia berdasarkan:

* Tanggal
* Lapangan

Status:

* Available
* Booked

---

## F4. Booking Court

User mengisi:

* Nama
* Nomor WhatsApp
* Tanggal
* Jam

Sistem menghasilkan kode booking unik.

Contoh:

PDL-2026-001

---

## F5. Booking Success

Menampilkan:

* Kode booking
* Detail venue
* Detail jadwal
* Instruksi pembayaran

---

## F6. WhatsApp Confirmation

Tombol:

"Kirim Bukti Pembayaran"

Membuka WhatsApp admin venue.

---

## F7. Admin Login

Admin dapat login menggunakan email dan password.

---

## F8. Booking Management

Admin dapat:

* Melihat booking
* Mengubah status booking

Status:

* Pending
* Confirmed
* Completed
* Cancelled

---

# 7. Non Functional Requirements

## Performance

* Loading halaman < 2 detik
* Booking tersimpan < 1 detik

## Security

* Hanya admin dapat mengakses dashboard
* Data booking tersimpan aman

## Reliability

* Tidak boleh terjadi double booking pada slot yang sama

---

# 8. Database Design

Tenant

* id
* name
* location
* phone

Court

* id
* tenant_id
* name
* price_per_hour

Booking

* id
* court_id
* customer_name
* customer_phone
* booking_date
* start_time
* end_time
* status

Admin

* id
* tenant_id
* email
* password

---

# 9. Technology Stack

Frontend

* Flutter
* Provider

Backend

* Supabase

Database

* PostgreSQL

Authentication

* Supabase Auth

Integration

* WhatsApp Deep Link

---

# 10. Success Metrics

* Booking berhasil dibuat
* Tidak ada double booking
* Admin dapat melihat seluruh booking
* Customer dapat menyelesaikan reservasi tanpa bantuan admin
