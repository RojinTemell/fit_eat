create table public.categories (
  id         uuid        primary key default gen_random_uuid(),
  slug       text        not null unique,
  name       text        not null,
  emoji      text,
  sort_order int         not null default 0,
  created_at timestamptz not null default now(),

  constraint categories_slug_format
    check (slug ~ '^[a-z0-9_]{2,40}$')
);

create index categories_sort_order_idx
  on public.categories (sort_order);

alter table public.categories enable row level security;

create policy "categories_select_public"
  on public.categories
  for select
  using (true);

insert into public.categories (slug, name, emoji, sort_order) values
  ('breakfast',   'Kahvaltı',      '🍳', 10),
  ('soup',        'Çorba',         '🥣', 20),
  ('salad',       'Salata',        '🥗', 30),
  ('main_course', 'Ana Yemek',     '🍽️', 40),
  ('snack',       'Atıştırmalık',  '🥨', 50),
  ('dessert',     'Tatlı',         '🍰', 60),
  ('drink',       'İçecek',        '🥤', 70),
  ('vegan',       'Vegan',         '🌱', 80),
  ('vegetarian',  'Vejetaryen',    '🥕', 90),
  ('gluten_free', 'Glutensiz',     '🌾', 100),
  ('world',       'Dünya Mutfağı', '🌍', 110),
  ('quick',       'Pratik',        '⚡', 120);