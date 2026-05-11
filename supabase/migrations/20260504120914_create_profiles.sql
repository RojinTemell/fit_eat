create table public.profiles (
  id              uuid        primary key references auth.users(id) on delete cascade,
  username        citext      not null unique,
  display_name    text,
  avatar_url      text,
  bio             text        check (bio is null or char_length(bio) <= 280),
  recipes_count   int         not null default 0,
  followers_count int         not null default 0,
  following_count int         not null default 0,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),


  constraint profiles_username_format
    check (username ~ '^[a-zA-Z0-9_]{3,30}$')
);

create index profiles_username_trgm_idx
  on public.profiles
  using gin (username gin_trgm_ops);



create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row
  execute function public.set_updated_at();


create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  default_username text;
begin
  default_username := 'user_' || substr(replace(new.id::text, '-', ''), 1, 8);

  insert into public.profiles (id, username, display_name, avatar_url)
  values (
    new.id,
    default_username,
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

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();



alter table public.profiles enable row level security;

-- SELECT: profile'lar public. Anonim de okuyabilir, authed de.
create policy "profiles_select_public"
  on public.profiles
  for select
  using (true);


create policy "profiles_update_own"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);


revoke update on public.profiles from anon, authenticated;
grant update (display_name, avatar_url, bio) on public.profiles to authenticated;