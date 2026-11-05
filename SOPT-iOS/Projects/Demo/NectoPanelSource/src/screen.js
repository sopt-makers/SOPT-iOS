import { necto } from "@necto/bridge";

import { call as rawCall, describe, statusFor } from "./common.js";

const setStatus = statusFor("screen");
const call = (operation, input) => rawCall(setStatus, operation, input);

const nameElement = document.getElementById("screen-name");
const detailElement = document.getElementById("screen-detail");
const rowsElement = document.getElementById("screen-rows");

// 최신 화면이 위로 오도록 앞쪽에 쌓는다.
let history = [];

function formatTime(iso) {
  const date = new Date(iso);
  return Number.isNaN(date.getTime()) ? iso : date.toLocaleTimeString("ko-KR", { hour12: false });
}

function renderCurrent(screen) {
  if (!screen) {
    nameElement.textContent = "-";
    detailElement.textContent = "아직 화면 전환이 없어요";
    return;
  }
  nameElement.textContent = screen.name;

  const parts = [];
  if (screen.module) parts.push(`module: ${screen.module}`);
  if (screen.title) parts.push(`title: ${screen.title}`);
  if (screen.path.length) parts.push(`in: ${screen.path.join(" › ")}`);
  detailElement.textContent = parts.join("  ·  ");
}

function renderHistory() {
  rowsElement.replaceChildren();
  for (const screen of history) {
    const row = document.createElement("tr");

    const time = document.createElement("td");
    time.textContent = formatTime(screen.time);

    const name = document.createElement("td");
    name.className = "key";
    name.textContent = screen.name;

    const module = document.createElement("td");
    module.textContent = screen.module;

    const title = document.createElement("td");
    title.textContent = screen.title;

    row.append(time, name, module, title);
    rowsElement.append(row);
  }
}

function add(screen) {
  // load와 observe가 겹쳐 같은 전환이 두 번 들어와도 id로 거른다.
  if (history.some((existing) => existing.id === screen.id)) return;
  history = [screen, ...history].slice(0, 100);
  renderCurrent(screen);
  renderHistory();
}

export async function load() {
  const result = await call("screen.history", {});
  history = [...result.screens].reverse();
  renderCurrent(history[0] ?? null);
  renderHistory();
}

export async function observe() {
  try {
    await necto.device.subscribe(
      "screen.observe",
      {},
      (message) => add(message.screen),
      (error) => setStatus(describe(error)),
    );
  } catch (error) {
    setStatus(describe(error));
  }
}
