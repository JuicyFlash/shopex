import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    dismissDiscountForm() {
        this.element.remove();
    }
}