// Navigation 메뉴를 누르면 해당 섹션으로 부드럽게 이동
// (링크의 href="#about" 과 섹션의 id="about" 이 짝을 이룸)
const navLinks = document.querySelectorAll('.nav-menu a');

navLinks.forEach(function (link) {
  link.addEventListener('click', function (event) {
    event.preventDefault();                           // 기본 순간 이동 막기
    const targetId = link.getAttribute('href');       // 예: "#about"
    const targetSection = document.querySelector(targetId);
    targetSection.scrollIntoView({ behavior: 'smooth' });
  });
});

// "메뉴 보기" 버튼을 누르면 Menu 섹션으로 부드럽게 이동
const menuBtn = document.getElementById('menuBtn');
const menuSection = document.getElementById('menu');

menuBtn.addEventListener('click', function () {
  menuSection.scrollIntoView({ behavior: 'smooth' });
});

// ------------------------------------------------------------
// Supabase에서 메뉴 불러오기
// ------------------------------------------------------------

// Supabase 대시보드 > Project Settings > API 에서 복사해서 붙여넣으세요.
const SUPABASE_URL = 'https://여기에-프로젝트-주소.supabase.co';
const SUPABASE_KEY = '여기에-publishable-key(또는 anon key)';

// 주소와 키를 넣었을 때만 연결 (넣기 전에는 HTML에 적힌 기본 카드가 그대로 보임)
if (!SUPABASE_URL.includes('여기에')) {
  const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
  loadMenu(supabaseClient);
}

async function loadMenu(client) {
  // menu 테이블에서 판매 중(is_available = true)인 메뉴만 sort_order 순서대로 가져오기
  const { data, error } = await client
    .from('menu')
    .select('*')
    .eq('is_available', true)
    .order('sort_order');

  if (error) {
    console.error('메뉴를 불러오지 못했습니다:', error.message);
    return; // 실패하면 기본 카드를 그대로 둠
  }

  const menuList = document.getElementById('menuList');
  menuList.innerHTML = ''; // 기본 카드 지우기

  data.forEach(function (item) {
    menuList.appendChild(createMenuCard(item));
  });
}

// 메뉴 하나(item)로 카드 하나 만들기
// 구조: 이미지 영역 → 이름 → 설명 → 가격 (HTML의 기존 카드와 동일)
function createMenuCard(item) {
  const card = document.createElement('div');
  card.className = 'menu-card';

  const imgBox = document.createElement('div');
  imgBox.className = 'menu-img';
  if (item.image_url) {
    const img = document.createElement('img');
    img.src = item.image_url;
    img.alt = item.name;
    imgBox.appendChild(img);
  } else {
    imgBox.textContent = '이미지 영역';
  }

  const name = document.createElement('h3');
  name.textContent = item.name;

  const desc = document.createElement('p');
  desc.textContent = item.description;

  const price = document.createElement('span');
  price.className = 'price';
  price.textContent = item.price.toLocaleString('ko-KR') + '원'; // 6500 → "6,500원"

  card.append(imgBox, name, desc, price);
  return card;
}
