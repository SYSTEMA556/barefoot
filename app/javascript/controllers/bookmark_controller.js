import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { novelId: Number }

  connect() {
    // 初期化処理
  }

  toggle(event) {
    event.preventDefault()
    // AJAX リクエスト送信 & ボタン更新
  }
}
