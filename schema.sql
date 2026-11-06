-- elsewhere — database setup. Paste into Supabase → SQL Editor → Run.

-- One small table holds comments, likes (saved places), reactions and reports.
-- Every person can only write their own row ("doc_id" = their user id).
create table if not exists public.kv (
  path        text primary key,
  collection  text not null check (collection in ('comments','likes','reactions','reports')),
  doc_id      text not null,
  data        jsonb not null default '{}'::jsonb check (octet_length(data::text) < 120000),
  updated_at  timestamptz not null default now()
);
create index if not exists kv_collection_idx on public.kv (collection);

-- Moderators (you). Add your own user id later — see README step 6.
create table if not exists public.admins (user_id uuid primary key);

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.admins where user_id = auth.uid()) $$;

alter table public.kv enable row level security;
alter table public.admins enable row level security;

-- Everyone can read comments, likes and reactions. Reports: only the reporter and admins.
drop policy if exists kv_read on public.kv;
create policy kv_read on public.kv for select
  using (collection <> 'reports' or doc_id = auth.uid()::text or public.is_admin());

-- Signed-in visitors (anonymous sign-in counts) can only create/change/delete their own row.
drop policy if exists kv_insert on public.kv;
create policy kv_insert on public.kv for insert to authenticated
  with check (doc_id = auth.uid()::text and path = collection || '/' || doc_id);

drop policy if exists kv_update on public.kv;
create policy kv_update on public.kv for update to authenticated
  using (doc_id = auth.uid()::text or public.is_admin())
  with check (doc_id = auth.uid()::text or public.is_admin());

drop policy if exists kv_delete on public.kv;
create policy kv_delete on public.kv for delete to authenticated
  using (doc_id = auth.uid()::text or public.is_admin());

drop policy if exists admins_self on public.admins;
create policy admins_self on public.admins for select using (user_id = auth.uid());

-- Live updates for comments / likes / reactions.
alter publication supabase_realtime add table public.kv;
