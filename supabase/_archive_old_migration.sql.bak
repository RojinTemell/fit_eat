-- ============================================================
-- FitEat — Initial Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- ─── USERS ───────────────────────────────────────────────────────────────────

create table public.users (
  id              uuid        primary key references auth.users(id) on delete cascade,
  username        text        unique not null,
  display_name    text,
  bio             text,
  avatar_url      text,
  recipe_count    int         not null default 0,
  follower_count  int         not null default 0,
  following_count int         not null default 0,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- Auto-create a public profile whenever a new auth user is created.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.users (id, username, display_name, avatar_url)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data->>'username', ''),
      nullif(split_part(new.email, '@', 1), ''),
      'user_' || substr(new.id::text, 1, 8)
    ),
    coalesce(
      new.raw_user_meta_data->>'full_name',
      new.raw_user_meta_data->>'name'
    ),
    new.raw_user_meta_data->>'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();


-- ─── RECIPES ─────────────────────────────────────────────────────────────────

create table public.recipes (
  id                  uuid        primary key default gen_random_uuid(),
  user_id             uuid        not null references public.users(id) on delete cascade,
  title               text        not null,
  description         text,
  difficulty          text        check (difficulty in ('easy', 'medium', 'hard')),
  duration_min        int,
  serving_count       int,
  calorie_per_serving int,
  categories          text[],
  ingredients         jsonb       not null default '[]',
  steps               jsonb       not null default '[]',
  cover_image_url     text,
  media               jsonb       not null default '[]',
  status              text        not null check (status in ('published', 'draft', 'archived')) default 'draft',
  like_count          int         not null default 0,
  comment_count       int         not null default 0,
  view_count          int         not null default 0,
  save_count          int         not null default 0,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);


-- ─── REELS ───────────────────────────────────────────────────────────────────

create table public.reels (
  id              uuid        primary key default gen_random_uuid(),
  user_id         uuid        not null references public.users(id) on delete cascade,
  recipe_id       uuid        references public.recipes(id) on delete set null,
  title           text,
  description     text,
  video_url       text        not null,
  thumbnail_url   text,
  duration_sec    int,
  like_count      int         not null default 0,
  comment_count   int         not null default 0,
  view_count      int         not null default 0,
  save_count      int         not null default 0,
  status          text        not null check (status in ('published', 'archived')) default 'published',
  created_at      timestamptz not null default now()
);


-- ─── LIKES ───────────────────────────────────────────────────────────────────

create table public.likes (
  id           uuid        primary key default gen_random_uuid(),
  user_id      uuid        not null references public.users(id) on delete cascade,
  content_id   uuid        not null,
  content_type text        not null check (content_type in ('recipe', 'reel')),
  created_at   timestamptz not null default now(),
  unique (user_id, content_id, content_type)
);

-- Trigger: keep like_count in sync on recipes/reels
create or replace function public.update_like_count()
returns trigger language plpgsql as $$
begin
  if (tg_op = 'INSERT') then
    if new.content_type = 'recipe' then
      update public.recipes set like_count = like_count + 1 where id = new.content_id;
    elsif new.content_type = 'reel' then
      update public.reels set like_count = like_count + 1 where id = new.content_id;
    end if;
  elsif (tg_op = 'DELETE') then
    if old.content_type = 'recipe' then
      update public.recipes set like_count = greatest(like_count - 1, 0) where id = old.content_id;
    elsif old.content_type = 'reel' then
      update public.reels set like_count = greatest(like_count - 1, 0) where id = old.content_id;
    end if;
  end if;
  return null;
end;
$$;

create trigger on_like_change
  after insert or delete on public.likes
  for each row execute function public.update_like_count();


-- ─── COMMENTS ────────────────────────────────────────────────────────────────

create table public.comments (
  id           uuid        primary key default gen_random_uuid(),
  user_id      uuid        not null references public.users(id) on delete cascade,
  content_id   uuid        not null,
  content_type text        not null check (content_type in ('recipe', 'reel')),
  parent_id    uuid        references public.comments(id) on delete cascade,
  body         text        not null,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- Trigger: keep comment_count in sync
create or replace function public.update_comment_count()
returns trigger language plpgsql as $$
begin
  if (tg_op = 'INSERT') then
    if new.content_type = 'recipe' then
      update public.recipes set comment_count = comment_count + 1 where id = new.content_id;
    elsif new.content_type = 'reel' then
      update public.reels set comment_count = comment_count + 1 where id = new.content_id;
    end if;
  elsif (tg_op = 'DELETE') then
    if old.content_type = 'recipe' then
      update public.recipes set comment_count = greatest(comment_count - 1, 0) where id = old.content_id;
    elsif old.content_type = 'reel' then
      update public.reels set comment_count = greatest(comment_count - 1, 0) where id = old.content_id;
    end if;
  end if;
  return null;
end;
$$;

create trigger on_comment_change
  after insert or delete on public.comments
  for each row execute function public.update_comment_count();


-- ─── VIEWS ───────────────────────────────────────────────────────────────────

create table public.content_views (
  id           uuid        primary key default gen_random_uuid(),
  user_id      uuid        references public.users(id) on delete set null,
  content_id   uuid        not null,
  content_type text        not null check (content_type in ('recipe', 'reel')),
  created_at   timestamptz not null default now(),
  unique (user_id, content_id, content_type)
);

-- Trigger: increment view_count (one view per user per content)
create or replace function public.update_view_count()
returns trigger language plpgsql as $$
begin
  if new.content_type = 'recipe' then
    update public.recipes set view_count = view_count + 1 where id = new.content_id;
  elsif new.content_type = 'reel' then
    update public.reels set view_count = view_count + 1 where id = new.content_id;
  end if;
  return null;
end;
$$;

create trigger on_view_insert
  after insert on public.content_views
  for each row execute function public.update_view_count();


-- ─── FOLLOWS ─────────────────────────────────────────────────────────────────

create table public.follows (
  follower_id  uuid        not null references public.users(id) on delete cascade,
  following_id uuid        not null references public.users(id) on delete cascade,
  created_at   timestamptz not null default now(),
  primary key (follower_id, following_id),
  check (follower_id != following_id)
);

-- Trigger: keep follower_count / following_count in sync
create or replace function public.update_follow_counts()
returns trigger language plpgsql as $$
begin
  if (tg_op = 'INSERT') then
    update public.users set following_count = following_count + 1 where id = new.follower_id;
    update public.users set follower_count  = follower_count  + 1 where id = new.following_id;
  elsif (tg_op = 'DELETE') then
    update public.users set following_count = greatest(following_count - 1, 0) where id = old.follower_id;
    update public.users set follower_count  = greatest(follower_count  - 1, 0) where id = old.following_id;
  end if;
  return null;
end;
$$;

create trigger on_follow_change
  after insert or delete on public.follows
  for each row execute function public.update_follow_counts();


-- ─── COLLECTIONS ─────────────────────────────────────────────────────────────

create table public.collections (
  id          uuid        primary key default gen_random_uuid(),
  user_id     uuid        not null references public.users(id) on delete cascade,
  name        text        not null,
  description text,
  cover_url   text,
  is_public   bool        not null default false,
  item_count  int         not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table public.collection_items (
  id            uuid        primary key default gen_random_uuid(),
  collection_id uuid        not null references public.collections(id) on delete cascade,
  content_id    uuid        not null,
  content_type  text        not null check (content_type in ('recipe', 'reel')),
  added_at      timestamptz not null default now(),
  unique (collection_id, content_id, content_type)
);

-- Trigger: keep item_count in sync
create or replace function public.update_collection_item_count()
returns trigger language plpgsql as $$
begin
  if (tg_op = 'INSERT') then
    update public.collections set item_count = item_count + 1 where id = new.collection_id;
  elsif (tg_op = 'DELETE') then
    update public.collections set item_count = greatest(item_count - 1, 0) where id = old.collection_id;
  end if;
  return null;
end;
$$;

create trigger on_collection_item_change
  after insert or delete on public.collection_items
  for each row execute function public.update_collection_item_count();


-- ─── BADGES ──────────────────────────────────────────────────────────────────

create table public.badges (
  id          uuid primary key default gen_random_uuid(),
  slug        text unique not null,
  title       text not null,
  description text,
  icon_url    text,
  criteria    jsonb not null default '{}'
);

create table public.user_badges (
  user_id   uuid        not null references public.users(id) on delete cascade,
  badge_id  uuid        not null references public.badges(id) on delete cascade,
  earned_at timestamptz not null default now(),
  primary key (user_id, badge_id)
);

-- Seed initial badge definitions
insert into public.badges (slug, title, description, criteria) values
  ('first_recipe',  'İlk Tarif',     'İlk tarifini paylaştın!',              '{"type":"recipe_count","threshold":1}'),
  ('five_recipes',  '5 Tarif Şefi',  '5 tarif paylaştın!',                   '{"type":"recipe_count","threshold":5}'),
  ('world_cuisine', 'Dünya Mutfağı', '3 farklı kategoride tarif paylaştın.', '{"type":"category_variety","threshold":3}'),
  ('social_chef',   'Sosyal Şef',    '10 takipçiye ulaştın!',                '{"type":"follower_count","threshold":10}');


-- ─── SHARES ──────────────────────────────────────────────────────────────────

create table public.shares (
  id           uuid        primary key default gen_random_uuid(),
  user_id      uuid        references public.users(id) on delete set null,
  content_id   uuid        not null,
  content_type text        not null check (content_type in ('recipe', 'reel')),
  platform     text,
  created_at   timestamptz not null default now()
);


-- ─── INGREDIENTS ─────────────────────────────────────────────────────────────

create table public.ingredients (
  id                uuid        primary key default gen_random_uuid(),
  name              text        not null,
  emoji             text,
  default_unit      text,
  calories_per_100g numeric,
  protein_per_100g  numeric,
  fat_per_100g      numeric,
  carbs_per_100g    numeric,
  grams_per_piece   numeric,
  approved          bool        not null default false,
  created_at        timestamptz not null default now()
);

create table public.ingredient_suggestions (
  id                uuid        primary key default gen_random_uuid(),
  user_id           uuid        references public.users(id) on delete set null,
  name              text        not null,
  emoji             text,
  default_unit      text,
  calories_per_100g numeric,
  status            text        not null check (status in ('pending', 'approved', 'rejected')) default 'pending',
  created_at        timestamptz not null default now()
);


-- ─── ROW LEVEL SECURITY ──────────────────────────────────────────────────────

alter table public.users                  enable row level security;
alter table public.recipes                enable row level security;
alter table public.reels                  enable row level security;
alter table public.likes                  enable row level security;
alter table public.comments               enable row level security;
alter table public.content_views          enable row level security;
alter table public.follows                enable row level security;
alter table public.collections            enable row level security;
alter table public.collection_items       enable row level security;
alter table public.badges                 enable row level security;
alter table public.user_badges            enable row level security;
alter table public.shares                 enable row level security;
alter table public.ingredients            enable row level security;
alter table public.ingredient_suggestions enable row level security;

-- USERS
create policy "Users are viewable by everyone"
  on public.users for select using (true);
create policy "Users can update their own profile"
  on public.users for update using (auth.uid() = id);

-- RECIPES
create policy "Published recipes viewable by everyone"
  on public.recipes for select using (status = 'published' or auth.uid() = user_id);
create policy "Authenticated users can create recipes"
  on public.recipes for insert with check (auth.uid() = user_id);
create policy "Users can update their own recipes"
  on public.recipes for update using (auth.uid() = user_id);
create policy "Users can delete their own recipes"
  on public.recipes for delete using (auth.uid() = user_id);

-- REELS
create policy "Published reels viewable by everyone"
  on public.reels for select using (status = 'published' or auth.uid() = user_id);
create policy "Authenticated users can create reels"
  on public.reels for insert with check (auth.uid() = user_id);
create policy "Users can update their own reels"
  on public.reels for update using (auth.uid() = user_id);
create policy "Users can delete their own reels"
  on public.reels for delete using (auth.uid() = user_id);

-- LIKES
create policy "Likes are viewable by everyone"
  on public.likes for select using (true);
create policy "Authenticated users can like"
  on public.likes for insert with check (auth.uid() = user_id);
create policy "Users can unlike"
  on public.likes for delete using (auth.uid() = user_id);

-- COMMENTS
create policy "Comments are viewable by everyone"
  on public.comments for select using (true);
create policy "Authenticated users can comment"
  on public.comments for insert with check (auth.uid() = user_id);
create policy "Users can delete their own comments"
  on public.comments for delete using (auth.uid() = user_id);

-- VIEWS
create policy "Anyone can record a view"
  on public.content_views for insert with check (true);
create policy "Views are viewable by everyone"
  on public.content_views for select using (true);

-- FOLLOWS
create policy "Follows are viewable by everyone"
  on public.follows for select using (true);
create policy "Authenticated users can follow"
  on public.follows for insert with check (auth.uid() = follower_id);
create policy "Users can unfollow"
  on public.follows for delete using (auth.uid() = follower_id);

-- COLLECTIONS
create policy "Public collections viewable by everyone"
  on public.collections for select
  using (is_public = true or auth.uid() = user_id);
create policy "Authenticated users can create collections"
  on public.collections for insert with check (auth.uid() = user_id);
create policy "Users can update their own collections"
  on public.collections for update using (auth.uid() = user_id);
create policy "Users can delete their own collections"
  on public.collections for delete using (auth.uid() = user_id);

-- COLLECTION ITEMS
create policy "Items in accessible collections are viewable"
  on public.collection_items for select
  using (
    exists (
      select 1 from public.collections c
      where c.id = collection_id
        and (c.is_public = true or c.user_id = auth.uid())
    )
  );
create policy "Users can add items to their own collections"
  on public.collection_items for insert
  with check (
    exists (
      select 1 from public.collections c
      where c.id = collection_id and c.user_id = auth.uid()
    )
  );
create policy "Users can remove items from their own collections"
  on public.collection_items for delete
  using (
    exists (
      select 1 from public.collections c
      where c.id = collection_id and c.user_id = auth.uid()
    )
  );

-- BADGES
create policy "Badges are viewable by everyone"
  on public.badges for select using (true);

-- USER BADGES
create policy "User badges are viewable by everyone"
  on public.user_badges for select using (true);

-- SHARES
create policy "Anyone can record a share"
  on public.shares for insert with check (true);

-- INGREDIENTS
create policy "Approved ingredients are viewable by everyone"
  on public.ingredients for select using (approved = true);

-- INGREDIENT SUGGESTIONS
create policy "Authenticated users can suggest ingredients"
  on public.ingredient_suggestions for insert
  with check (auth.uid() = user_id);
create policy "Users can see their own suggestions"
  on public.ingredient_suggestions for select
  using (auth.uid() = user_id);
