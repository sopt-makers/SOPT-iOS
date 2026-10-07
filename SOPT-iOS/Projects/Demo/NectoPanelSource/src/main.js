import { necto } from "@necto/bridge";

import * as amplitude from "./amplitude.js";
import * as link from "./link.js";
import * as screen from "./screen.js";
import * as userDefaults from "./userdefaults.js";

const TAB_KEY = "sopt-debug.tab";

function selectTab(name) {
  for (const button of document.querySelectorAll(".tab")) {
    button.classList.toggle("selected", button.dataset.tab === name);
  }
  for (const panel of document.querySelectorAll(".tab-panel")) {
    panel.hidden = panel.id !== `tab-${name}`;
  }
  try {
    localStorage.setItem(TAB_KEY, name);
  } catch {
    // 저장소를 못 쓰는 환경이면 선택만 유지하지 않는다.
  }
}

function savedTab() {
  try {
    return localStorage.getItem(TAB_KEY) ?? "userdefaults";
  } catch {
    return "userdefaults";
  }
}

async function main() {
  if (!necto.isAvailable()) {
    document.getElementById("userdefaults-status").textContent = "Necto 안에서만 동작합니다";
    return;
  }

  for (const button of document.querySelectorAll(".tab")) {
    button.addEventListener("click", () => selectTab(button.dataset.tab));
  }
  selectTab(savedTab());

  userDefaults.setup();
  amplitude.setup();
  link.setup();

  // 한 기능이 실패해도 다른 기능은 계속 뜨도록 각각 시도한다. 실패 이유는 call()이 상태 문구에 남긴다.
  await userDefaults.refresh().catch(() => {});
  await amplitude.load().catch(() => {});
  await amplitude.observe();
  await screen.load().catch(() => {});
  await screen.observe();

  // 모든 핸들러를 등록한 뒤에 알린다. 호스트는 그때까지 이벤트를 버퍼링한다.
  await necto.ready();
}

void main();
