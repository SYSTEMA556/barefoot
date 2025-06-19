// app/javascript/theme_toggle.js
document.addEventListener("turbo:load", () => {
  const btn = document.getElementById("theme-toggle");
  if (!btn) return;

  btn.addEventListener("click", () => {
    const html = document.documentElement;
    const next = html.dataset.theme === "dark" ? "light" : "dark";
    html.dataset.theme = next;
    localStorage.setItem("theme", next);
  });

  // 初期化
  const saved = localStorage.getItem("theme");
  if (saved) document.documentElement.dataset.theme = saved;
});
