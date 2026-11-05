import { necto, isNectoBridgeError } from "@necto/bridge";

export function describe(error) {
  return isNectoBridgeError(error) ? `${error.code}: ${error.message}` : String(error);
}

/** 탭마다 자기 상태 문구를 갖도록 `<tab>-status` 요소를 감싼다. */
export function statusFor(tab) {
  const element = document.getElementById(`${tab}-status`);
  return (text) => {
    element.textContent = text;
  };
}

/** 실패하면 `setStatus`에 이유를 띄우고 에러를 그대로 던진다. */
export async function call(setStatus, operation, input) {
  try {
    return await necto.device.send(operation, input);
  } catch (error) {
    setStatus(describe(error));
    throw error;
  }
}

export function button(label, handler) {
  const element = document.createElement("button");
  element.type = "button";
  element.className = "necto-button";
  element.textContent = label;
  element.addEventListener("click", handler);
  return element;
}
