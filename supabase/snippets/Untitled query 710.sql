  select conname, conrelid::regclass, confrelid::regclass, confdeltype
   from pg_constraint
   where contype = 'f'
     and conrelid::regclass::text in ('public.recipe_ingredients');    