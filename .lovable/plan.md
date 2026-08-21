# Tenant Dokumen, Menu SOP, dan Kamar Kosong per Lantai

## 1. Form Tenant: KTP, Kartu Identitas, dan Foto Tenant

Bagian "Dokumen" pada form tambah/edit tenant dipecah menjadi tiga unggahan terpisah:

- **KTP** — unggah foto/scan KTP (gambar atau PDF).
- **Kartu Mahasiswa / Pelajar / SIM** — unggah kartu identitas kedua.
- **Foto Tenant** — slot khusus foto tenant, dan ikut terisi otomatis: begitu ada gambar diunggah di KTP atau kartu identitas dan slot foto masih kosong, gambar pertama itu langsung dipakai sebagai foto tenant. Bisa diganti atau dihapus manual kapan saja.

Unggahan "Dokumen lain" (kontrak, surat perjanjian) tetap ada untuk berkas lainnya, dan dokumen tenant yang sudah tersimpan sekarang tetap muncul di sana.

Foto tenant ditampilkan sebagai avatar di daftar tenant dan di dialog detail tenant, bersama pratinjau KTP dan kartu identitas.

## 2. Menu SOP dengan Submenu per Bagian

Menu utama mendapat item **SOP** (desktop: dropdown; mobile: bagian yang bisa dibuka-tutup) berisi 15 submenu yang membuka halaman peraturan di tab baru, langsung ke bagiannya:

1. Penerimaan Tenant, 2. Penggunaan Internet, 3. Penyimpanan Barang & Kendaraan, 4. Fasilitas Bersama, 5. Air & Listrik, 6. Komplain Fasilitas, 7. Penerimaan Barang & Paket, 8. Keadaan Darurat, 9. Penggunaan APAR, 10. Kunjungan Tamu, 11. Ketertiban & Ketenangan, 12. Ketentuan Umum, Pernyataan Kepatuhan, Pendaftaran Calon Penghuni, serta "Buka Semua SOP" ke halaman utama.

## 3. Ringkasan: Kamar Belum Terisi per Lantai

Di halaman Ringkasan ditambah kartu **Kamar Belum Terisi** yang merinci per lantai (1, 2, 3): jumlah kamar kosong dari total kamar di lantai itu, plus total kamar kosong keseluruhan. Kamar dihitung terisi bila ada tenant berstatus aktif yang menempatinya. Tiap baris lantai bisa diklik menuju daftar kamar lantai tersebut.

## Catatan Teknis

- **Migrasi database** pada tabel `tenants`: tambah `ktp_files jsonb default '[]'`, `id_card_files jsonb default '[]'`, `photo_path text`. Tanpa perubahan aturan akses (mengikuti kebijakan tabel yang ada).
- `src/lib/tenants.ts`: tambah field baru ke `TenantProfile`, `TenantProfilePayload`, `SELECT`, dan mapping (pakai helper `strings`) serta simpan di create/update.
- `src/components/TenantFullFormDialog.tsx`: tiga `ProofUploader`/`PhotoUploader` baru + logika auto-isi `photo_path` dari gambar pertama (filter ekstensi gambar, abaikan PDF) saat slot masih kosong.
- `src/components/AppShell.tsx`: konstanta `SOP_SECTIONS` (label + anchor) dan dropdown/collapsible baru dengan `target="_blank" rel="noopener noreferrer"` ke `https://lavin-rules-simplified.lovable.app/#<anchor>`.
- `src/routes/index.tsx`: hitung okupansi dari `tenantProfilesQuery` (status aktif, `room_id`/`room_number`) terhadap `roomsQuery`, tampilkan kartu per lantai.
