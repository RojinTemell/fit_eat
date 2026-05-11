select id, public,
       round(file_size_limit / 1024.0 / 1024.0)::int as size_mb,
       allowed_mime_types
from storage.buckets
order by id;

select policyname, cmd
from pg_policies
where schemaname = 'storage' and tablename = 'objects'
order by policyname;