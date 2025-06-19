// app/javascript/application.js
import { Application } from "@hotwired/stimulus"
import ToggleController from "./controllers/toggle_controller"

window.Stimulus = Application.start()
Stimulus.register("toggle", ToggleController)
