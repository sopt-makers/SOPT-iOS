import { necto } from "@necto/bridge";

import { call as rawCall, describe, statusFor } from "./common.js";

const setStatus = statusFor("amplitude");
const call = (operation, input) => rawCall(setStatus, operation, input);

const rowsElement = document.getElementById("amp-rows");
const filterElement = document.getElementById("amp-filter");

// 최신 이벤트가 위로 오도록 앞쪽에 쌓는다.
let events = [];

function formatTime(iso) {
  const date = new Date(iso);
  return Number.isNaN(date.getTime()) ? iso : date.toLocaleTimeString("ko-KR", { hour12: false });
}

function render() {
  const query = filterElement.value.trim().toLowerCase();
  rowsElement.replaceChildren();

  for (const event of events) {
    if (query && !`${event.name} ${event.properties}`.toLowerCase().includes(query)) continue;

    const row = document.createElement("tr");

    const time = document.createElement("td");
    time.textContent = formatTime(event.time);

    const name = document.createElement("td");
    name.className = "key";
    name.textContent = event.name;

    const properties = document.createElement("td");
    properties.className = "properties";
    properties.textContent = event.properties;

    row.append(time, name, properties);
    rowsElement.append(row);
  }
}

function add(event) {
  // list와 observe가 겹쳐 같은 이벤트가 두 번 들어와도 id로 거른다.
  if (events.some((existing) => existing.id === event.id)) return;
  events = [event, ...events].slice(0, 500);
  render();
}

export async function load() {
  const result = await call("amplitude.list", {});
  events = [...result.events].reverse();
  render();
}

export async function observe() {
  try {
    await necto.device.subscribe(
      "amplitude.observe",
      {},
      (message) => add(message.event),
      (error) => setStatus(describe(error)),
    );
  } catch (error) {
    setStatus(describe(error));
  }
}

export function setup() {
  filterElement.addEventListener("input", render);

  document.getElementById("amp-clear").addEventListener("click", async () => {
    await call("amplitude.clear", {});
    events = [];
    render();
  });
}
