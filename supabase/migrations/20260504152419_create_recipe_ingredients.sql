create table public.ingredients (
  id           uuid        primary key default gen_random_uuid(),
  name         text        not null unique,
  default_unit text,
  created_at   timestamptz not null default now(),

  constraint ingredients_name_not_empty check (length(trim(name)) > 0),
  constraint ingredients_name_min_length check (length(name) >= 2)
);
create index ingredients_name_lower_idx
  on public.ingredients (lower(name));


alter table public.ingredients enable row level security;

create policy "ingredients_select_public"
  on public.ingredients
  for select
  using (true);

-- Seed: Türk mutfağı temel malzemeleri (MVP başlangıç pool'u)
insert into public.ingredients (name, default_unit) values
  -- Sebzeler
  ('Soğan',            'adet'),
  ('Sarımsak',         'diş'),
  ('Domates',          'adet'),
  ('Patates',          'adet'),
  ('Havuç',            'adet'),
  ('Yeşil biber',      'adet'),
  ('Kırmızı biber',    'adet'),
  ('Patlıcan',         'adet'),
  ('Kabak',            'adet'),
  ('Salatalık',        'adet'),
  ('Maydanoz',         'demet'),
  ('Dereotu',          'demet'),
  ('Limon',            'adet'),
  -- Et / protein
  ('Tavuk göğsü',      'g'),
  ('Kıyma',            'g'),
  ('Kuzu eti',         'g'),
  ('Yumurta',          'adet'),
  -- Süt ürünleri
  ('Süt',              'ml'),
  ('Yoğurt',           'g'),
  ('Tereyağ',          'g'),
  ('Beyaz peynir',     'g'),
  ('Kaşar peyniri',    'g'),
  -- Tahıl / bakliyat
  ('Un',               'g'),
  ('Pirinç',           'g'),
  ('Bulgur',           'g'),
  ('Mercimek',         'g'),
  ('Nohut',            'g'),
  ('Makarna',          'g'),
  -- Yağ / baharat
  ('Zeytinyağı',       'ml'),
  ('Ayçiçek yağı',     'ml'),
  ('Tuz',              'g'),
  ('Karabiber',        'g'),
  ('Pul biber',        'g'),
  ('Kekik',            'g'),
  ('Nane',             'g'),
  -- Diğer
  ('Şeker',            'g'),
  ('Bal',              'g'),
  ('Su',               'ml'),
  ('Sirke',            'ml'),
  ('Salça',            'g');

create or replace function public.is_recipe_visible(p_recipe_id uuid)
returns boolean
language sql
stable
security invoker
as $$
  select exists (
    select 1 from public.recipes r
    where r.id = p_recipe_id
      and (r.status = 'published' or r.author_id = (select auth.uid()))
  );
$$;

create or replace function public.is_recipe_owner(p_recipe_id uuid)
returns boolean
language sql
stable
security invoker
as $$
  select exists (
    select 1 from public.recipes r
    where r.id = p_recipe_id
      and r.author_id = (select auth.uid())
  );
$$;

create table public.recipe_ingredients (
  id            uuid        primary key default gen_random_uuid(),
  recipe_id     uuid        not null references public.recipes(id) on delete cascade,
  ingredient_id uuid        not null references public.ingredients(id) on delete restrict,
  quantity      numeric(10, 2),
  unit          text,
  note          text,
  sort_order    int         not null default 0,
  created_at    timestamptz not null default now(),

  constraint recipe_ingredients_quantity_nonneg
    check (quantity is null or quantity >= 0)
);

create index recipe_ingredients_recipe_idx
  on public.recipe_ingredients (recipe_id, sort_order);

create index recipe_ingredients_ingredient_idx
  on public.recipe_ingredients (ingredient_id);

alter table public.recipe_ingredients enable row level security;

create policy "recipe_ingredients_select"
  on public.recipe_ingredients
  for select
  using (public.is_recipe_visible(recipe_id));

create policy "recipe_ingredients_insert_own"
  on public.recipe_ingredients
  for insert
  with check (public.is_recipe_owner(recipe_id));

create policy "recipe_ingredients_update_own"
  on public.recipe_ingredients
  for update
  using (public.is_recipe_owner(recipe_id))
  with check (public.is_recipe_owner(recipe_id));

create policy "recipe_ingredients_delete_own"
  on public.recipe_ingredients
  for delete
  using (public.is_recipe_owner(recipe_id));