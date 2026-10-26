-- 1. ตารางเก็บโปรไฟล์ผู้ใช้งาน
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text,
  username text,
  role text default 'student',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. ตารางห้องเรียน
create table public.classes (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  subject text not null,
  room text,
  code text unique not null,
  teacher_id uuid references public.profiles(id) on delete cascade,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. ตารางงานและการบ้าน
create table public.tasks (
  id uuid default gen_random_uuid() primary key,
  class_id uuid references public.classes(id) on delete cascade,
  title text not null,
  description text,
  max_score numeric default 10,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- เปิดสิทธิ์ RLS (Row Level Security) สำหรับอ่าน/เขียนข้อมูลทั่วไป
alter table public.profiles enable row level security;
alter table public.classes enable row level security;
alter table public.tasks enable row level security;

create policy "Allow public read access on profiles" on public.profiles for select using (true);
create policy "Allow insert on profiles" on public.profiles for insert with check (true);
create policy "Allow public read access on classes" on public.classes for select using (true);
create policy "Allow authenticated insert on classes" on public.classes for insert with check (auth.role() = 'authenticated');
create policy "Allow public read access on tasks" on public.tasks for select using (true);