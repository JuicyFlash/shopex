import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    page: String,
    path: String,
  }

  connect() {
    
  }
  AddPath() {
    window.history.replaceState(window.history.state, this.pageValue, this.pathValue)
  }
}