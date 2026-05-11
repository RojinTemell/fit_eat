-- FITEAT — profiles.recipes_count counter trigger
--
-- Amaç: profiles.recipes_count, ilgili kullanıcının status='published'
-- tarif sayısını tutsun. Client'tan asla yazılamasın.
--
-- Tetiklenme:
--   * INSERT  status='published'                       → +1
--   * DELETE  eski status='published'                  → -1
--   * UPDATE  published'a geçiş                        → +1
--   * UPDATE  published'tan çıkış (draft/archived)     → -1
--   * UPDATE  author_id değişti (defansif)             → eski yazardan -1, yeni yazara +1
--
-- Notlar:
--   * security definer: trigger RLS'i ve column-level grant'ı bypass etmeli;
--     kullanıcının profiles.recipes_count'a doğrudan update yetkisi yok.
--   * set search_path = public: security definer fonksiyonlarda injection
--     koruması için zorunlu pratik.
--   * greatest(.. - 1, 0): herhangi bir tutarsızlıkta sayaç negatife kaçmasın.

create or replace function public.tg_recipes_recount_author()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if (tg_op = 'INSERT') then
    if (new.status = 'published') then
      update public.profiles
         set recipes_count = recipes_count + 1
       where id = new.author_id;
    end if;
    return null;
  end if;

  if (tg_op = 'DELETE') then
    if (old.status = 'published') then
      update public.profiles
         set recipes_count = greatest(recipes_count - 1, 0)
       where id = old.author_id;
    end if;
    return null;
  end if;

  -- UPDATE
  if (old.author_id is distinct from new.author_id) then
    -- Author değişimi: defansif; pratikte olmaz ama edge case'i yakala.
    if (old.status = 'published') then
      update public.profiles
         set recipes_count = greatest(recipes_count - 1, 0)
       where id = old.author_id;
    end if;
    if (new.status = 'published') then
      update public.profiles
         set recipes_count = recipes_count + 1
       where id = new.author_id;
    end if;
  else
    -- Aynı yazar: status geçişi
    if (old.status = 'published' and new.status <> 'published') then
      update public.profiles
         set recipes_count = greatest(recipes_count - 1, 0)
       where id = new.author_id;
    elsif (old.status <> 'published' and new.status = 'published') then
      update public.profiles
         set recipes_count = recipes_count + 1
       where id = new.author_id;
    end if;
  end if;

  return null;
end;
$$;

create trigger recipes_recount_author
  after insert or update or delete on public.recipes
  for each row
  execute function public.tg_recipes_recount_author();
