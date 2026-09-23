-- ============================================================
-- MELLOW BEAN 메뉴 테이블
-- 사용법: Supabase 대시보드 > SQL Editor > New query
--         이 파일 내용을 전부 붙여넣고 Run 을 누르세요.
-- 여러 번 실행해도 테이블이나 데이터가 중복으로 생기지 않습니다.
-- ============================================================


-- 1. 메뉴 테이블 만들기 ------------------------------------------
create table if not exists public.menu (
  id           bigint generated always as identity primary key,
  name         text    not null,                     -- 메뉴 이름 (예: Cream Latte)
  description  text,                                 -- 메뉴 설명
  price        integer not null check (price >= 0),  -- 가격, 숫자만 (예: 6500)
  category     text    not null default 'coffee'     -- 종류: coffee / dessert / beverage
               check (category in ('coffee', 'dessert', 'beverage')),
  image_url    text,                                 -- 메뉴 이미지 주소 (없으면 비워두기)
  sort_order   integer not null default 0,           -- 화면 순서 (작은 숫자가 먼저)
  is_available boolean not null default true,        -- false로 바꾸면 화면에서 숨김 (품절 등)
  created_at   timestamptz not null default now()    -- 등록 시간 (자동)
);


-- 2. 보안 설정: 웹페이지 방문자는 메뉴를 "읽기"만 가능 -------------
alter table public.menu enable row level security;

drop policy if exists "누구나 메뉴 읽기 가능" on public.menu;
create policy "누구나 메뉴 읽기 가능"
  on public.menu
  for select
  to anon, authenticated
  using (true);

grant select on public.menu to anon, authenticated;


-- 3. 현재 웹페이지 메뉴 3개 넣기 (테이블이 비어 있을 때만) ----------
insert into public.menu (name, description, price, category, sort_order)
select * from (values
  ('Cream Latte',      '부드러운 크림과 에스프레소가 어우러진 시그니처 라떼',   6500, 'coffee',   1),
  ('Classic Tiramisu', '진한 마스카포네 크림과 커피 향을 담은 수제 티라미수',   7000, 'dessert',  2),
  ('Mellow Ade',       '레몬과 허브를 사용한 상큼한 시그니처 에이드',          6000, 'beverage', 3)
) as v(name, description, price, category, sort_order)
where not exists (select 1 from public.menu);


-- 4. 확인: 들어간 메뉴 보기 --------------------------------------
select id, name, price, category, sort_order, is_available
from public.menu
order by sort_order;
