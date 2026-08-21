ALTER TABLE public.room_items ADD CONSTRAINT room_items_code_unique UNIQUE (code);
ALTER TABLE public.shared_items ADD CONSTRAINT shared_items_code_unique UNIQUE (code);