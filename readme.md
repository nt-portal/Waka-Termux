# WakaTime untuk Termux

WakaTime untuk Termux memungkinkan Anda melacak aktivitas coding secara otomatis langsung dari shell Anda. Pantau produktivitas Anda dan lacak berapa banyak waktu yang Anda habiskan untuk berbagai proyek yang berbeda.

---

## Prasyarat

Direkomendasikan untuk menggunakan versi Termux dari F-Droid atau GitHub, karena versi Play Store sudah usang.

- [F-Droid](https://f-droid.org/packages/com.termux)
- [GitHub Releases](https://github.com/termux/termux-app/releases)

---

## Instalasi

1. **Daftar**: Daftar akun WakaTime di [wakatime.com](https://wakatime.com).
2. **Jalankan Installer**:

   ```bash
   curl -sL https://github.com/nt-portal/Waka-Termux/raw/main/install.sh | bash
   ```

3. **Konfigurasi**: Installer akan membuka `~/.wakatime.cfg`. Tempel API key Anda di sana. Anda dapat menemukan API key Anda di [pengaturan akun WakaTime](https://wakatime.com/settings/account).

4. **Muat Ulang Shell**: Jalankan `source ~/.bashrc` atau mulai ulang terminal Anda untuk mulai melacak.

---

## Fitur

- Pelacakan otomatis aktivitas shell.
- Deteksi proyek berdasarkan direktori saat ini.
- Mendukung 450+ bahasa pemrograman dan 870+ ekstensi file.
- Backup harian otomatis untuk folder proyek (`~/.wakatime/backups`).
- Eksekusi di latar belakang untuk menghindari terminal lag.

---

[Donasi](https://saweria.co/ntdonate) untuk kebutuhan saya.
