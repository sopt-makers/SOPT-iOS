import { button, call as rawCall, statusFor } from "./common.js";

const setStatus = statusFor("userdefaults");
const call = (operation, input) => rawCall(setStatus, operation, input);

const rowsElement = document.getElementById("ud-rows");
const filterElement = document.getElementById("ud-filter");

let entries = [];

export async function refresh() {
  const result = await call("userdefaults.list", {});
  entries = result.entries;
  render();
  setStatus(`UserDefaults ${entries.length}개`);
}

function valueEditor(entry) {
  if (entry.type === "bool") {
    const select = document.createElement("select");
    select.className = "necto-input value-input";
    for (const option of ["true", "false"]) {
      const element = document.createElement("option");
      element.value = element.textContent = option;
      select.append(element);
    }
    select.value = entry.value === "true" ? "true" : "false";
    return select;
  }
  const input = document.createElement("input");
  input.className = "necto-input value-input";
  input.value = entry.exists ? entry.value : "";
  input.placeholder = entry.exists ? "" : "(없음)";
  return input;
}

function render() {
  const query = filterElement.value.trim().toLowerCase();
  rowsElement.replaceChildren();

  for (const entry of entries) {
    if (query && !entry.key.toLowerCase().includes(query)) continue;

    const row = document.createElement("tr");
    if (!entry.exists) row.className = "missing";

    const key = document.createElement("td");
    key.className = "key";
    key.textContent = entry.key;

    const type = document.createElement("td");
    type.textContent = entry.exists ? entry.type : "-";

    const editor = valueEditor(entry);
    const value = document.createElement("td");
    value.append(editor);

    const actions = document.createElement("td");
    actions.className = "actions";

    // 타입을 모르는 키(데이터, 배열 등)는 문자열로만 덮어쓸 수 있다.
    const writeType = ["bool", "number", "string"].includes(entry.type) ? entry.type : "string";
    actions.append(button("저장", () => save(entry.key, writeType, editor.value)));
    if (entry.exists) {
      actions.append(
        button("삭제", async () => {
          if (!confirm(`${entry.key} 를 삭제할까요?`)) return;
          await call("userdefaults.remove", { key: entry.key });
          await refresh();
        }),
      );
    }

    row.append(key, type, value, actions);
    rowsElement.append(row);
  }
}

async function save(key, type, value) {
  await call("userdefaults.set", { key, type, value });
  await refresh();
}

export function setup() {
  document.getElementById("ud-refresh").addEventListener("click", () => void refresh());
  filterElement.addEventListener("input", render);

  document.getElementById("ud-add").addEventListener("submit", async (event) => {
    event.preventDefault();
    const key = document.getElementById("ud-add-key").value.trim();
    const type = document.getElementById("ud-add-type").value;
    const value = document.getElementById("ud-add-value").value;
    if (!key) return;
    await save(key, type, value);
  });
}
