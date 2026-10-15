import { call as rawCall, statusFor } from "./common.js";

const setStatus = statusFor("link");
const call = (operation, input) => rawCall(setStatus, operation, input);

const STORAGE_KEY = "sopt-debug.push";

// 처음 열었을 때 채워 둘 값. 자주 쓰는 apns 예시와 같다.
const DEFAULTS = {
  title: "테스트",
  body: "안녕하세요",
  id: "2133",
  category: "NOTICE",
  deepLink: "home/notification/detail?id=596",
  webLink: "",
  delay: "1",
};

const fields = {
  title: document.getElementById("push-title"),
  body: document.getElementById("push-body"),
  id: document.getElementById("push-id"),
  category: document.getElementById("push-category"),
  deepLink: document.getElementById("push-deeplink"),
  webLink: document.getElementById("push-weblink"),
  delay: document.getElementById("push-delay"),
};

function loadValues() {
  try {
    return { ...DEFAULTS, ...JSON.parse(localStorage.getItem(STORAGE_KEY) ?? "{}") };
  } catch {
    return { ...DEFAULTS };
  }
}

function saveValues() {
  const values = Object.fromEntries(Object.entries(fields).map(([key, element]) => [key, element.value]));
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(values));
  } catch {
    // 저장소를 못 쓰는 환경이면 다음에 기본값으로 시작한다.
  }
}

async function run(label, action) {
  try {
    await action();
    setStatus(`${label} 완료 (${new Date().toLocaleTimeString("ko-KR", { hour12: false })})`);
  } catch {
    // call()이 실패 이유를 상태 문구에 남겼다.
  }
}

export function setup() {
  const values = loadValues();
  for (const [key, element] of Object.entries(fields)) element.value = values[key];

  document.getElementById("push-form").addEventListener("submit", (event) => {
    event.preventDefault();
    saveValues();
    const delaySeconds = Number(fields.delay.value);
    void run(`푸시 예약 (${delaySeconds}초 뒤)`, () =>
      call("push.send", {
        title: fields.title.value,
        body: fields.body.value,
        id: fields.id.value,
        category: fields.category.value,
        deepLink: fields.deepLink.value,
        webLink: fields.webLink.value,
        delaySeconds,
      }),
    );
  });

  document.getElementById("deeplink-form").addEventListener("submit", (event) => {
    event.preventDefault();
    const deepLink = document.getElementById("open-deeplink").value.trim();
    void run("딥링크 열기", () => call("link.deeplink", { deepLink }));
  });

  document.getElementById("weblink-form").addEventListener("submit", (event) => {
    event.preventDefault();
    const webLink = document.getElementById("open-weblink").value.trim();
    void run("웹링크 열기", () => call("link.weblink", { webLink }));
  });
}
