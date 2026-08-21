CREATE OR REPLACE FUNCTION public.generate_inventory_code()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_abbr TEXT;
  v_date DATE;
  v_seq INTEGER;
  v_code TEXT;
  v_table TEXT;
BEGIN
  v_table := TG_TABLE_NAME;
  v_abbr := upper(substr(regexp_replace(NEW.name, '[^A-Za-z]', '', 'g'), 1, 3));
  IF v_abbr IS NULL OR v_abbr = '' THEN
    v_abbr := 'ITM';
  END IF;

  v_date := COALESCE(NEW.purchase_date, CURRENT_DATE);

  IF v_table = 'room_items' THEN
    SELECT COALESCE(MAX(
      CAST(SPLIT_PART(code, '-', 3) AS INTEGER)
    ), 0) + 1
    INTO v_seq
    FROM public.room_items
    WHERE code LIKE v_abbr || '-' || to_char(v_date, 'DDMMYY') || '-%';
  ELSIF v_table = 'shared_items' THEN
    SELECT COALESCE(MAX(
      CAST(SPLIT_PART(code, '-', 3) AS INTEGER)
    ), 0) + 1
    INTO v_seq
    FROM public.shared_items
    WHERE code LIKE v_abbr || '-' || to_char(v_date, 'DDMMYY') || '-%';
  ELSE
    v_seq := 1;
  END IF;

  v_code := v_abbr || '-' || to_char(v_date, 'DDMMYY') || '-' || lpad(v_seq::text, 2, '0');
  NEW.code := v_code;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS room_items_generate_code ON public.room_items;
CREATE TRIGGER room_items_generate_code
BEFORE INSERT ON public.room_items
FOR EACH ROW
WHEN (NEW.code IS NULL OR NEW.code = '')
EXECUTE FUNCTION public.generate_inventory_code();

DROP TRIGGER IF EXISTS shared_items_generate_code ON public.shared_items;
CREATE TRIGGER shared_items_generate_code
BEFORE INSERT ON public.shared_items
FOR EACH ROW
WHEN (NEW.code IS NULL OR NEW.code = '')
EXECUTE FUNCTION public.generate_inventory_code();