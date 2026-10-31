-- NH Car Care: bookings database
-- Already applied to the nh-car-care Supabase project. Kept here for reference /
-- to rebuild the database: Supabase > SQL Editor > paste > Run.

create table if not exists public.bookings (
  id             uuid primary key default gen_random_uuid(),
  created_at     timestamptz not null default now(),
  name           text not null check (char_length(name) between 1 and 100),
  phone          text not null check (char_length(phone) between 5 and 30),
  area           text not null check (char_length(area) between 1 and 200),
  car            text check (char_length(car) <= 100),
  service        text not null check (service in ('exterior', 'interior', 'full')),
  price          numeric(8,2),
  preferred_date date not null,
  preferred_time text not null check (preferred_time in ('morning', 'afternoon', 'evening')),
  looking_for    text check (char_length(looking_for) <= 1000),
  status         text not null default 'pending' check (status in ('pending', 'done', 'cancelled')),
  admin_notes    text check (char_length(admin_notes) <= 1000)
);

-- New bookings always start as "pending", with the price set from the service.
-- (Customers can't send their own price or status.)
create or replace function public.set_booking_defaults()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.status      := 'pending';
  new.admin_notes := null;
  new.created_at  := now();
  new.price := case new.service
                 when 'exterior' then 40
                 when 'interior' then 30
                 when 'full'     then 60
               end;
  return new;
end;
$$;

drop trigger if exists bookings_set_defaults on public.bookings;
create trigger bookings_set_defaults
  before insert on public.bookings
  for each row execute function public.set_booking_defaults();

-- Security: anyone can CREATE a booking, only the admin can SEE or CHANGE them.
alter table public.bookings enable row level security;

drop policy if exists "Anyone can create a booking" on public.bookings;
create policy "Anyone can create a booking"
  on public.bookings for insert
  to anon, authenticated
  with check (true);

drop policy if exists "Admin can read bookings" on public.bookings;
create policy "Admin can read bookings"
  on public.bookings for select
  to authenticated
  using ((select auth.jwt() ->> 'email') = 'admin@nhcarcare.com');

drop policy if exists "Admin can update bookings" on public.bookings;
create policy "Admin can update bookings"
  on public.bookings for update
  to authenticated
  using ((select auth.jwt() ->> 'email') = 'admin@nhcarcare.com')
  with check ((select auth.jwt() ->> 'email') = 'admin@nhcarcare.com');

drop policy if exists "Admin can delete bookings" on public.bookings;
create policy "Admin can delete bookings"
  on public.bookings for delete
  to authenticated
  using ((select auth.jwt() ->> 'email') = 'admin@nhcarcare.com');
