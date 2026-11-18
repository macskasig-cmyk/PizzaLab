-- PizzaLab community schema for Supabase
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'PizzaLab-tag',
  created_at timestamptz not null default now()
);
create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  caption text not null check (char_length(caption) between 1 and 2000),
  image_url text,
  created_at timestamptz not null default now()
);
create table if not exists public.likes (
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key(post_id,user_id)
);
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 1000),
  created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.likes enable row level security;
alter table public.comments enable row level security;
create policy "profiles readable" on public.profiles for select using (true);
create policy "users create own profile" on public.profiles for insert with check (auth.uid()=id);
create policy "users update own profile" on public.profiles for update using (auth.uid()=id);
create policy "posts readable" on public.posts for select using (true);
create policy "users create own posts" on public.posts for insert with check (auth.uid()=user_id);
create policy "users delete own posts" on public.posts for delete using (auth.uid()=user_id);
create policy "likes readable" on public.likes for select using (true);
create policy "users manage own likes" on public.likes for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "comments readable" on public.comments for select using (true);
create policy "users create own comments" on public.comments for insert with check (auth.uid()=user_id);
create policy "users delete own comments" on public.comments for delete using (auth.uid()=user_id);
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  insert into public.profiles(id, display_name)
  values(new.id, coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email,'@',1)));
  return new;
end;
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('pizza-photos','pizza-photos',true,8388608,array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;
create policy "community photos public read" on storage.objects for select using (bucket_id='pizza-photos');
create policy "users upload own community photos" on storage.objects for insert to authenticated
with check (bucket_id='pizza-photos' and (storage.foldername(name))[1]=auth.uid()::text);
create policy "users delete own community photos" on storage.objects for delete to authenticated
using (bucket_id='pizza-photos' and (storage.foldername(name))[1]=auth.uid()::text);
create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  reason text not null check (char_length(reason) between 1 and 1000),
  status text not null default 'pending' check (status in ('pending','reviewed','dismissed')),
  created_at timestamptz not null default now(),
  unique(post_id, reporter_id)
);
alter table public.reports enable row level security;
create policy "users submit own reports" on public.reports for insert to authenticated
with check (auth.uid()=reporter_id);
create policy "users read own reports" on public.reports for select to authenticated
using (auth.uid()=reporter_id);
