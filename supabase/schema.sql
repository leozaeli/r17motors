-- Execute this file once in Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.vehicles (
  id uuid primary key default gen_random_uuid(), slug text unique not null,
  brand text not null, model text not null, version text,
  year integer, mileage integer, price numeric,
  color text, transmission text, fuel text, description text,
  status text not null default 'draft' check (status in ('draft','published','sold')),
  featured boolean not null default false,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.vehicle_images (
  id uuid primary key default gen_random_uuid(), vehicle_id uuid not null references public.vehicles(id) on delete cascade,
  path text not null, alt text, position integer not null default 0, created_at timestamptz not null default now()
);
alter table public.vehicles enable row level security;
alter table public.vehicle_images enable row level security;
create policy "public reads published vehicles" on public.vehicles for select using (status = 'published');
create policy "public reads images" on public.vehicle_images for select using (true);
create policy "authenticated manage vehicles" on public.vehicles for all to authenticated using (true) with check (true);
create policy "authenticated manage vehicle images" on public.vehicle_images for all to authenticated using (true) with check (true);

insert into storage.buckets (id, name, public) values ('vehicle-media', 'vehicle-media', true) on conflict (id) do update set public = true;
create policy "public reads vehicle media" on storage.objects for select using (bucket_id = 'vehicle-media');
create policy "authenticated uploads vehicle media" on storage.objects for insert to authenticated with check (bucket_id = 'vehicle-media');
create policy "authenticated updates vehicle media" on storage.objects for update to authenticated using (bucket_id = 'vehicle-media') with check (bucket_id = 'vehicle-media');
create policy "authenticated deletes vehicle media" on storage.objects for delete to authenticated using (bucket_id = 'vehicle-media');
