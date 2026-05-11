-- FITEAT — ingredients tablosuna emoji kolonu ekler.
--
-- Ingredient picker UI'da malzemenin yanında 🥕🥚🌶️ gösterimi için.
-- (categories tablosunda zaten emoji var; simetri için ingredients'a da
-- aynısını ekliyoruz.)
--
-- Idempotent: kolon zaten varsa hata vermez.
-- Nutrition kolonları (calories_per_100g, protein_per_100g, ...) bilerek
-- EKLENMEZ — calorie auto-compute V2 işidir, MVP'de ingredient sadece
-- name + default_unit + emoji taşır.

alter table public.ingredients
  add column if not exists emoji text;
