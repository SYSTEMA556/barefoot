// app/javascript/application.js
import "@hotwired/turbo-rails"
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "controllers"
import Rails from "@rails/ujs"
Rails.start()
import "@hotwired/turbo-rails"

Rails.start()
ActiveStorage.start()


// app/javascript/packs/application.js
document.addEventListener("DOMContentLoaded", () => {
  const fontSelect = document.getElementById("font-select");
  const preview   = document.getElementById("preview-area");
  const bodyField = document.querySelector("#novel-form textarea[name='novel[body]']");

  // フォント選択変更でプレビューの font-family を更新
  if (fontSelect && preview) {
    fontSelect.addEventListener("change", () => {
      preview.style.fontFamily = fontSelect.value;
    });
  }

  // 本文入力時にも即時プレビュー反映
  if (bodyField && preview) {
    bodyField.addEventListener("input", () => {
      // 改行を <br> に変換してプレビュー
      const text = bodyField.value
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/\r?\n/g, "<br>");
      preview.innerHTML = text || "ここにプレビューが表示されます…";
    });
  }
});
