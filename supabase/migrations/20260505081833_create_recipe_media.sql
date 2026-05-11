-- FITEAT — recipe_media
-- Tarif kapak/galeri medyası. image + video destekli (şema seviyesinde).
-- ⚠ Video upload UI'sı V2'ye kadar app tarafında kapalı tutulmalı
--   (storage / egress maliyeti — bkz. mimari plan §7).

create type public.media_type as enum ('image', 'video');

create table public.recipe_media (
  id               uuid             primary key default gen_random_uuid(),
  recipe_id        uuid             not null references public.recipes(id) on delete cascade,
  url              text             not null,
  thumbnail_url    text,
  media_type       public.media_type not null,
  width            int,
  height           int,
  duration_seconds int,             -- sadece video için anlamlı
  sort_order       int              not null default 0,
  created_at       timestamptz      not null default now(),
  updated_at       timestamptz      not null default now(),

  constraint recipe_media_url_not_empty
    check (length(trim(url)) > 0),

  -- Pozitif boyutlar (NULL serbest, sıfır/negatif değil).
  constraint recipe_media_width_positive
    check (width is null or width > 0),
  constraint recipe_media_height_positive
    check (height is null or height > 0),

  -- Image satırlarında duration_seconds taşınmasın.
  constraint recipe_media_image_no_duration
    check (media_type <> 'image' or duration_seconds is null),

  -- duration_seconds verilmişse pozitif olsun.
  constraint recipe_media_duration_positive
    check (duration_seconds is null or duration_seconds > 0)
);

-- Medyaları sıraya göre çekmek için.
create index recipe_media_recipe_idx
  on public.recipe_media (recipe_id, sort_order);

create trigger recipe_media_set_updated_at
  before update on public.recipe_media
  for each row
  execute function public.set_updated_at();

alter table public.recipe_media enable row level security;

create policy "recipe_media_select"
  on public.recipe_media
  for select
  using (public.is_recipe_visible(recipe_id));

create policy "recipe_media_insert_own"
  on public.recipe_media
  for insert
  with check (public.is_recipe_owner(recipe_id));

create policy "recipe_media_update_own"
  on public.recipe_media
  for update
  using (public.is_recipe_owner(recipe_id))
  with check (public.is_recipe_owner(recipe_id));

create policy "recipe_media_delete_own"
  on public.recipe_media
  for delete
  using (public.is_recipe_owner(recipe_id));
