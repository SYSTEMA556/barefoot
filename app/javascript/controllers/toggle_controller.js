// app/javascript/controllers/toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    this.toggle() // ← 初期化で実行！
  }

  toggle() {
    const textarea = document.getElementById("caution-reason-field")
    textarea.style.display = this.checkboxTarget.checked ? "block" : "none"
  }
}
