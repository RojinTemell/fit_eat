create type public.recipe_difficulty as enum ('easy', 'medium', 'hard');
-- draft     → yazar yazıyor, public göremiyor, sadece yazar erişiyor
-- published → yayında, herkes görüyor
-- archived  → yazar kaldırdı (soft delete), sadece yazar görüyor,
--             istediğinde geri published'a alabilir
create type public.recipe_status as enum ('draft', 'published', 'archived');

create table public.recipes (
  id                 uuid        primary key default gen_random_uuid(),
  author_id          uuid        not null references public.profiles(id) on delete cascade,

  -- İçerik
  title              text        not null,
  slug               text        not null,
  description        text,
  cover_image_url    text,

  -- Yemek metadata
  cook_time_minutes  int,
  servings           int,
  difficulty         public.recipe_difficulty,

  -- Yayın akışı
  status             public.recipe_status not null default 'draft',
  published_at       timestamptz,

  -- Counter sütunları (client'tan yazılamaz; Aşama 4'te trigger üstünden artacak)
  like_count         int         not null default 0,
  save_count         int         not null default 0,
  comment_count      int         not null default 0,
  view_count         int         not null default 0,

  -- Audit
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),

  -- Constraint'ler
  constraint recipes_title_not_empty
    check (length(trim(title)) > 0),
  constraint recipes_slug_format
    check (slug ~ '^[a-z0-9-]{2,80}$'),
  constraint recipes_servings_positive
    check (servings is null or servings > 0),
  constraint recipes_prep_time_nonneg
    check (prep_time_minutes is null or prep_time_minutes >= 0),
  constraint recipes_cook_time_nonneg
    check (cook_time_minutes is null or cook_time_minutes >= 0),
  constraint recipes_published_has_date
    check (status <> 'published' or published_at is not null),

  -- Aynı yazar aynı slug'ı iki kez kullanamaz; farklı yazarlar kullanabilir.
  -- URL routing: /users/{username}/recipes/{slug}
  constraint recipes_slug_unique_per_author
    unique (author_id, slug)
);

create index recipes_author_id_idx
  on public.recipes (author_id);
create index recipes_status_idx
  on public.recipes (status);

create index recipes_feed_idx
  on public.recipes (published_at desc, author_id)
  where status = 'published';

create trigger recipes_set_updated_at
  before update on public.recipes
  for each row
  execute function public.set_updated_at();


create or replace function public.tg_recipes_set_published_at()
returns trigger
language plpgsql
as $$
begin
  if new.status = 'published' and (old is null or old.status is distinct from 'published') then
    new.published_at := coalesce(new.published_at, now());
  end if;
  return new;
end;
$$;

create trigger recipes_set_published_at
  before insert or update of status on public.recipes
  for each row
  execute function public.tg_recipes_set_published_at();

alter table public.recipes enable row level security;

create policy "recipes_select_public_or_own"
  on public.recipes
  for select
  using (
    status = 'published'
    or author_id = (select auth.uid())
  );

-- INSERT: kullanıcı sadece kendi adına tarif yaratabilir.
create policy "recipes_insert_own"
  on public.recipes
  for insert
  with check (author_id = (select auth.uid()));

create policy "recipes_update_own"
  on public.recipes
  for update
  using (author_id = (select auth.uid()))
  with check (author_id = (select auth.uid()));

-- DELETE: yazar kendi tarifini silebilir.
create policy "recipes_delete_own"
  on public.recipes
  for delete
  using (author_id = (select auth.uid()));

revoke insert (like_count, save_count, comment_count, view_count, published_at)
  on public.recipes
  from authenticated, anon;

revoke update (like_count, save_count, comment_count, view_count, published_at)
  on public.recipes
  from authenticated, anon;