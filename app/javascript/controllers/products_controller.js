import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismissAddProductForm() {    
    this.element.remove();
  }
}
