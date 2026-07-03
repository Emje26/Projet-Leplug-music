import { Controller } from "@hotwired/stimulus"

// Recalcule le récapitulatif de réservation en direct quand
// l'utilisateur change la durée (sous-total, frais, total).
export default class extends Controller {
  static targets = ["subtotal", "fee", "total"]
  static values = { hourly: Number, feeRate: Number }

  connect() {
    this.refresh()
  }

  refresh() {
    const checked = this.element.querySelector("input[name*='duration_hours']:checked")
    if (!checked) return

    const hours = parseFloat(checked.value)
    const subtotal = hours * this.hourlyValue
    const fee = subtotal * this.feeRateValue

    this.subtotalTarget.textContent = this.format(subtotal)
    this.feeTarget.textContent = this.format(fee)
    this.totalTarget.textContent = this.format(subtotal + fee)
  }

  format(amount) {
    return `€${amount.toFixed(2)}`
  }
}
