CREATE OR REPLACE FUNCTION public.inventory_code(_name text, _date date, _seq int)
RETURNS text LANGUAGE sql IMMUTABLE SET search_path = public AS $$
  SELECT rpad(upper(substring(regexp_replace(coalesce(_name,''), '[^A-Za-z]', '', 'g') from 1 for 3)), 3, 'X')
      || '-' || to_char(_date, 'DDMMYY') || '-' || lpad(_seq::text, 2, '0')
$$;

WITH all_items AS (
  SELECT 'room'::text AS src, id, name, purchase_date, code, created_at FROM public.room_items
  UNION ALL
  SELECT 'shared'::text, id, name, purchase_date, code, created_at FROM public.shared_items
),
prefixed AS (
  SELECT *, rpad(upper(substring(regexp_replace(coalesce(name,''), '[^A-Za-z]', '', 'g') from 1 for 3)), 3, 'X')
    || '-' || to_char(purchase_date, 'DDMMYY') AS prefix
  FROM all_items WHERE purchase_date IS NOT NULL
),
numbered AS (
  SELECT src, id, prefix || '-' || lpad(row_number() OVER (PARTITION BY prefix ORDER BY created_at, id)::text, 2, '0') AS new_code
  FROM prefixed
)
UPDATE public.room_items r SET code = n.new_code
FROM numbered n WHERE n.src = 'room' AND n.id = r.id AND r.code IS DISTINCT FROM n.new_code;

WITH all_items AS (
  SELECT 'room'::text AS src, id, name, purchase_date, created_at FROM public.room_items
  UNION ALL
  SELECT 'shared'::text, id, name, purchase_date, created_at FROM public.shared_items
),
prefixed AS (
  SELECT *, rpad(upper(substring(regexp_replace(coalesce(name,''), '[^A-Za-z]', '', 'g') from 1 for 3)), 3, 'X')
    || '-' || to_char(purchase_date, 'DDMMYY') AS prefix
  FROM all_items WHERE purchase_date IS NOT NULL
),
numbered AS (
  SELECT src, id, prefix || '-' || lpad(row_number() OVER (PARTITION BY prefix ORDER BY created_at, id)::text, 2, '0') AS new_code
  FROM prefixed
)
UPDATE public.shared_items s SET code = n.new_code
FROM numbered n WHERE n.src = 'shared' AND n.id = s.id AND s.code IS DISTINCT FROM n.new_code;