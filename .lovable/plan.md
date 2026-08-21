Salin kode aplikasi "Invite Hub" (repositori https://github.com/backuparisanto2-cloud/social-inviter-link) ke proyek Lovable yang sedang aktif.

Aplikasi sumber adalah proyek Lovable lengkap berbasis TanStack Start + Tailwind v4 yang mencakup:
- Manajemen inventaris kamar/fasilitas bersama (Lavin Kost Purwokerto)
- Manajemen tenant, pendapatan, pengeluaran, jurnal umum, dan laporan
- Integrasi Lovable Cloud / Supabase dengan 6 migration SQL
- 126 file sumber, 10+ route, serta asset gambar dan ikon publik

Karena proyek aktif saat ini masih template kosong tanpa Lovable Cloud, rencana kerja disusun sebagai berikut.

## Rencana Implementasi

### 1. Aktifkan Lovable Cloud
Aplikasi sumber bergantung pada Supabase (Lovable Cloud). Langkah pertama: aktifkan Lovable Cloud pada proyek aktif agar Supabase client, environment variable, dan migration dapat bekerja.

### 2. Salin kode sumber utama
Salin file/folder dari repo sumber ke proyek aktif:
- `src/components/*` (AppShell, form dialog, FloorPlanMap, dll.)
- `src/lib/*` (logika inventaris, expense, income, journal, report, AI functions, dll.)
- `src/integrations/supabase/*` (client, types, auth middleware, attacher)
- `src/routes/*` (semua route: `/`, `/denah`, `/fasilitas`, `/jurnal`, `/kamar`, `/kelola`, `/laporan`, `/pendapatan`, `/pengeluaran`, `/tenant`)
- `src/styles.css` (design system + tema gold)
- `src/start.ts` (memuat `attachSupabaseAuth` middleware)
- `src/assets/*` (asset metadata)
- Abaikan `src/routeTree.gen.ts` — akan diregenerasi otomatis oleh TanStack Router.
- Abaikan `src/routes/__root.tsx` dan `src/routes/index.tsx` dari sementara, lalu gabungkan secara manual: `__root.tsx` perlu menambahkan `<SplashScreen />` dan `<Toaster />` tanpa menghapus `QueryClientProvider` / `Outlet` yang sudah ada.

### 3. Gabungkan dependensi
Tambahkan dependency yang belum ada di proyek aktif:
- `@supabase/supabase-js`
- `jspdf`
- `jspdf-autotable`
- `pdfjs-dist`
- `xlsx`

Jalankan `bun install` setelah package.json diperbarui.

### 4. Salin asset publik
Salin seluruh folder `public/` dari repo sumber, termasuk:
- Ikon PWA (`app-icon.png`, `app-icon-192.png`, `manifest.webmanifest`, `favicon.ico`, `favicon.png`)
- Gambar denah lantai dan splash building

### 5. Salin migration dan Supabase types
Salin folder `supabase/migrations/` ke proyek aktif. Supabase types (`src/integrations/supabase/types.ts`) ikut disalin.

### 6. Update environment variable
Tidak menyalin file `.env` dari repo sumber (berisi credential proyek Supabase lain). Setelah Lovable Cloud aktif, gunakan credential Supabase yang diberikan proyek aktif ini. Pastikan variabel yang dibaca kode sesuai:
- `VITE_SUPABASE_URL` / `SUPABASE_URL`
- `VITE_SUPABASE_PUBLISHABLE_KEY` / `SUPABASE_PUBLISHABLE_KEY`
- `VITE_SUPABASE_PROJECT_ID` / `SUPABASE_PROJECT_ID`

### 7. Terapkan migration ke database baru
Jalankan migration SQL dari `supabase/migrations/` secara berurutan di database Lovable Cloud proyek aktif. Migration mencakup pembuatan tabel (rooms, room_items, shared_items, conditions, expenses, tenants, incomes, dll.), seed data (32 kamar, item default, kondisi, lokasi pengeluaran), policy RLS, storage bucket policy, dan trigger.

### 8. Build dan verifikasi
Jalankan build (`vite build` / `build:dev`) untuk memastikan tidak ada error. Periksa log build dan runtime. Jika muncul error, perbaiki sesuai pesan error (misalnya missing import, type mismatch, atau route conflict). Verifikasi route utama dan integrasi Supabase dapat berjalan.

## Catatan Penting

- Aplikasi sumber memakai policy RLS "public full access" untuk banyak tabel (anon + authenticated). Setelah Lovable Cloud aktif, migration ini akan membuat struktur data dan akses yang sama, namun menggunakan instance Supabase yang baru milik proyek aktif.
- Data seed (32 kamar, item, dll.) akan dihasilkan ulang di database baru, sehingga aplikasi aktif akan memiliki data awal yang sama.
- Jika Lovable Cloud gagal diaktifkan atau credential tidak tersedia, aplikasi tidak bisa melakukan query ke Supabase dan build/runtime akan error. Oleh karena itu, aktivasi Lovable Cloud adalah langkah kunci pertama.
