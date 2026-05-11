-- FITEAT — recipe_categories
-- Tarif ↔ kategori M:N ilişki tablosu.
-- Bir tarif birden fazla kategoride listelenebilir (örn. "Ana Yemek" + "Vegan").

create table public.recipe_categories (
  recipe_id   uuid        not null references public.recipes(id)    on delete cascade,
  category_id uuid        not null references public.categories(id) on delete restrict,
  created_at  timestamptz not null default now(),

  -- Aynı tarife aynı kategori iki kez eklenemez.
  primary key (recipe_id, category_id)
);

-- "Bu kategoride hangi tarifler var" sorgusu için ters yön index.
-- (PK zaten recipe_id öncelikli; category_id öncelikli ayrı index gerek.)
create index recipe_categories_category_idx
  on public.recipe_categories (category_id, recipe_id);

alter table public.recipe_categories enable row level security;

-- SELECT: tarif görünür ise (published veya kendi draft'ı) bağlama satırı görünür.
create policy "recipe_categories_select"
  on public.recipe_categories
  for select
  using (public.is_recipe_visible(recipe_id));

-- INSERT/DELETE: sadece tarifin sahibi.
-- UPDATE policy yok — composite PK olduğu için update mantıklı değil
-- (silip yeniden ekle).
create policy "recipe_categories_insert_own"
  on public.recipe_categories
  for insert
  with check (public.is_recipe_owner(recipe_id));

create policy "recipe_categories_delete_own"
  on public.recipe_categories
  for delete
  using (public.is_recipe_owner(recipe_id));
