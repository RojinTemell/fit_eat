-- FITEAT — Storage bucket'ları + RLS policy'leri
--
-- Üç public bucket:
--   * recipe-images → tarif kapak ve galeri görselleri (max 5 MB)
--   * recipe-videos → tarif videoları (max 100 MB) — UI V2'ye kadar kapalı
--   * avatars       → profil resimleri (max 2 MB)
--
-- Image ve video bucket'ları AYRI tutuluyor:
--   * Farklı boyut/mime limiti (5 MB image vs 100 MB video)
--   * Farklı transcode pipeline'ı (V2'de Edge Function trigger'ları bucket bazlı)
--   * Farklı egress maliyet profili (video çok daha pahalı)
--   * Sonradan ayırmak migration acısı; baştan ayrı kurulur.
--
-- Path konvansiyonu (RLS için kritik):
--   recipe-images/{user_id}/{recipe_id}/{uuid}.jpg
--   recipe-videos/{user_id}/{recipe_id}/{uuid}.mp4
--   avatars/{user_id}/{uuid}.jpg
--
-- İlk segment her zaman {user_id} olmalı; RLS bunu zorlar.
-- Flutter repo katmanında upload pattern'i:
--   final path = '${userId}/$recipeId/${Uuid().v4()}.jpg';
--   await supabase.storage.from('recipe-images').upload(path, file);

-- ─── Bucket'lar ─────────────────────────────────────────────────────────────

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'recipe-images',
  'recipe-images',
  true,                                    -- public read; CDN üzerinden direkt URL
  5 * 1024 * 1024,                         -- 5 MB
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif'
  ]::text[]
)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'recipe-videos',
  'recipe-videos',
  true,                                    -- public read; ileride signed URL'e çevrilebilir
  100 * 1024 * 1024,                       -- 100 MB (raw upload; V2'de transcode pipeline'ı azaltır)
  array[
    'video/mp4',
    'video/quicktime',
    'video/webm'
  ]::text[]
)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatars',
  'avatars',
  true,
  2 * 1024 * 1024,                         -- 2 MB
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif'
  ]::text[]
)
on conflict (id) do nothing;


-- ─── RLS: recipe-images ─────────────────────────────────────────────────────

create policy "recipe_images_objects_select_public"
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'recipe-images');

create policy "recipe_images_objects_insert_own"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'recipe-images'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "recipe_images_objects_update_own"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'recipe-images'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  )
  with check (
    bucket_id = 'recipe-images'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "recipe_images_objects_delete_own"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'recipe-images'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );


-- ─── RLS: recipe-videos ─────────────────────────────────────────────────────

create policy "recipe_videos_objects_select_public"
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'recipe-videos');

create policy "recipe_videos_objects_insert_own"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'recipe-videos'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "recipe_videos_objects_update_own"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'recipe-videos'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  )
  with check (
    bucket_id = 'recipe-videos'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "recipe_videos_objects_delete_own"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'recipe-videos'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );


-- ─── RLS: avatars ───────────────────────────────────────────────────────────

create policy "avatars_objects_select_public"
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'avatars');

create policy "avatars_objects_insert_own"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "avatars_objects_update_own"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  )
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

create policy "avatars_objects_delete_own"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );
