import { Controller } from "@hotwired/stimulus"

// Ajoute l'état "scrolled" (fond flouté + bordure) à la topbar de la landing.
export default class extends Controller {
  connect() {
    this.onScroll = () => {
      this.element.classList.toggle("scrolled", window.scrollY > 30)
    }
    this.onScroll()
    window.addEventListener("scroll", this.onScroll, { passive: true })
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
  }
}
