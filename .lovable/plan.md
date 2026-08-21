# Menu Barang Inventaris, Side Menu Scroll, Splash Terang

## 1. Ganti nama & gabung jadi submenu
- "Kamar" menjadi **Inventaris Kamar**, "Fasilitas Utama" menjadi **Inventaris Fasilitas Utama**.
- Keduanya dikeluarkan dari menu utama dan dijadikan submenu dari menu baru **Barang Inventaris**.
- Menu utama jadi: Ringkasan, Barang Inventaris (submenu: Inventaris Kamar, Inventaris Fasilitas Utama), Denah, Tenant & Pembayaran, Kelola Data, Laporan, Akuntansi, SOP.
- Berlaku sama di navigasi desktop (dropdown) dan side menu mobile (grup yang bisa dibuka/tutup).
- Judul di halaman /kamar dan /fasilitas ikut diselaraskan dengan nama baru.

## 2. Side menu bisa di-scroll
- Panel side menu dibuat tinggi penuh dengan area navigasi yang bisa di-scroll vertikal, sedangkan header "Menu" dan kontrol ukuran teks tetap terlihat.
- Grup SOP yang panjang tidak lagi terpotong; scroll halus dan tetap nyaman di layar kecil.

## 3. Splash screen baru: sederhana, elegan, terang
- Ganti latar foto gelap dengan latar terang (putih hangat/krem) beraksen emas yang sudah jadi identitas aplikasi.
- Isi: logo aplikasi, nama "Lavin Kost Purwokerto", satu baris subjudul, garis pemisah tipis, dan indikator loading halus.
- Animasi lembut (fade + naik sedikit), tetap tampil sekali per sesi, bisa di-tap untuk dilewati, durasi tetap singkat.

## Catatan teknis
- Perubahan menu dan scroll ada di `src/components/AppShell.tsx` (array `nav` + grup baru, `SheetContent` pakai flex kolom dengan `overflow-y-auto` pada nav).
- Splash di `src/components/SplashScreen.tsx`: hapus pemakaian aset foto gelap, pakai token warna terang; keyframes tambahan bila perlu di `src/styles.css`.
- Tidak ada perubahan database atau logika bisnis.
