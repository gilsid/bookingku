# BookingKu ⚽

Aplikasi reservasi lapangan **mini soccer** (futsal) berbasis Flutter.

## Fitur

- **Auth** — Login/register dengan email atau nomor telepon
- **Home** — Daftar lapangan populer, promo, dan banner
- **Field** — Detail lapangan, jadwal, dan harga sewa
- **Booking** — Pilih jadwal, konfirmasi, dan dapatkan tiket
- **Payment** — Upload bukti transfer, status pembayaran
- **History** — Riwayat booking dan ticket digital
- **Notification** — Notifikasi status booking dan promo
- **Profile** — Edit profil, ganti password

## Tech Stack

| Lapisan        | Teknologi                               |
| -------------- | --------------------------------------- |
| Framework      | Flutter (+ Dart)                        |
| State Mgmt     | Provider + ChangeNotifier               |
| Navigation     | GoRouter (ShellRoute untuk tab bottom)  |
| Local Storage  | SharedPreferences                       |
| Arsitektur     | Clean Architecture (feature-based)      |

## Memulai

```bash
flutter pub get
flutter run
```

Login demo: `ahmad.reza@email.com` / `081234567890` — password `12345678`

## Struktur

```
lib/
├── core/          # Theme, routes, network, constants, utils
├── features/      # 9 modul fitur (auth, booking, home, dll.)
│   └── [feature]/ # data/ domain/ presentation/
└── shared/        # Widget umum, model, extensions
```

Data saat ini menggunakan **mock datasource** (simulasi `Future.delayed`). Saat backend REST API siap, ganti dengan `RemoteDatasource` — endpoint sudah didefinisikan di `ApiEndpoints`.

## Pengembangan

```bash
flutter analyze     # Linting
flutter test        # Test
```

## Keterbatasan

- **Mock data** — Semua data masih simulasi, belum terhubung REST API
- **Belum ada admin panel** — Manajemen lapangan, booking, dan user via web belum tersedia
- **Notifikasi lokal** — Hanya notifikasi in-app, push notification belum diimplementasikan
