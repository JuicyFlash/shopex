import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismissAddPropertyForm() {    
    this.element.remove();
  }
}
