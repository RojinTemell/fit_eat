-- FITEAT — recipe_steps
-- Tarif adımları. MVP: sadece text instruction.
-- (image_url ve duration_seconds ileride alter table ile eklenebilir.)

create table public.recipe_steps (
  id          uuid        primary key default gen_random_uuid(),
  recipe_id   uuid        not null references public.recipes(id) on delete cascade,
  step_number int         not null,
  instruction text        not null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),

  -- Adım numarası 1'den başlar.
  constraint recipe_steps_step_number_positive
    check (step_number > 0),

  -- Boş veya sadece boşluk girilemez.
  constraint recipe_steps_instruction_not_empty
    check (length(trim(instruction)) > 0),

  -- Çok uzun adımlara karşı koruma.
  constraint recipe_steps_instruction_max_length
    check (char_length(instruction) <= 2000),

  -- Aynı tarifte iki kez aynı sıra numarası olamaz.
  constraint recipe_steps_unique_per_recipe
    unique (recipe_id, step_number)
);

-- Adımları sırayla çekmek için (en sık erişim pattern'i).
create index recipe_steps_recipe_idx
  on public.recipe_steps (recipe_id, step_number);

create trigger recipe_steps_set_updated_at
  before update on public.recipe_steps
  for each row
  execute function public.set_updated_at();

alter table public.recipe_steps enable row level security;

create policy "recipe_steps_select"
  on public.recipe_steps
  for select
  using (public.is_recipe_visible(recipe_id));

create policy "recipe_steps_insert_own"
  on public.recipe_steps
  for insert
  with check (public.is_recipe_owner(recipe_id));

create policy "recipe_steps_update_own"
  on public.recipe_steps
  for update
  using (public.is_recipe_owner(recipe_id))
  with check (public.is_recipe_owner(recipe_id));

create policy "recipe_steps_delete_own"
  on public.recipe_steps
  for delete
  using (public.is_recipe_owner(recipe_id));
