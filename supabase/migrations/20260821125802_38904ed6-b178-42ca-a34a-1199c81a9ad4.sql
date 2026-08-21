ALTER TABLE public.tenants
  ADD COLUMN IF NOT EXISTS ktp_files jsonb NOT NULL DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS id_card_files jsonb NOT NULL DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS photo_path text;