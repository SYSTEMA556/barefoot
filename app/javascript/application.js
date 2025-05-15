// app/javascript/application.js
import "@hotwired/turbo-rails"
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "controllers"

Rails.start()
ActiveStorage.start()
