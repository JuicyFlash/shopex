import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = [ "flash" ]
    connect(){ this.show_flash()
    }    
    show_flash() {
        const element = this.flashTarget
        element.hidden = false
        const toastBootstrap = bootstrap.Toast.getOrCreateInstance(element)
        toastBootstrap.show()
       
    }
    dismiss() {
        this.element.remove();
      }
}
