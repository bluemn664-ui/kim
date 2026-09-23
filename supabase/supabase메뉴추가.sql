-- ============================================================
-- MELLOW BEAN 메뉴 5개 추가
-- 사용법: supabase.sql 을 먼저 실행한 뒤,
--         SQL Editor > New query 에 이 파일 내용을 붙여넣고 Run 을 누르세요.
-- 같은 이름의 메뉴가 이미 있으면 건너뛰므로 여러 번 실행해도 중복되지 않습니다.
-- ============================================================


-- 1. 메뉴 5개 추가 ----------------------------------------------
insert into public.menu (name, description, price, category, sort_order)
select v.name, v.description, v.price, v.category, v.sort_order
from (values
  ('Mellow Americano', '고소한 견과류 풍미의 하우스 블렌드로 내린 깔끔한 아메리카노',   4500, 'coffee',   4),
  ('Honey Oat Latte',  '귀리 우유와 꿀이 더해져 은은하게 달콤한 라떼',                5800, 'coffee',   5),
  ('Basque Cheesecake','겉은 진하게 구워내고 속은 촉촉하게 완성한 바스크 치즈케이크',   6800, 'dessert',  6),
  ('Butter Scone',     '매일 아침 매장에서 굽는 버터 향 가득한 스콘',                 3800, 'dessert',  7),
  ('Grapefruit Tea',   '직접 담근 자몽청으로 만든 따뜻하고 향긋한 과일차',             5500, 'beverage', 8)
) as v(name, description, price, category, sort_order)
where not exists (
  select 1 from public.menu m where m.name = v.name
);


-- 2. 확인: 전체 메뉴 보기 ----------------------------------------
select id, name, price, category, sort_order, is_available
from public.menu
order by sort_order;
