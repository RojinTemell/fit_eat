-- FITEAT — recipes tablosundan prep_time_minutes alanını ve ilgili
-- check constraint'ini kaldırır. Tek bir 'cook_time_minutes' alanı yeter
-- kabul edildi. Idempotent: var olmayan obje varsa hata vermez.

alter table public.recipes
  drop constraint if exists recipes_prep_time_nonneg;

alter table public.recipes
  drop column if exists prep_time_minutes;
