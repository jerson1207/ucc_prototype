import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable"
export default class extends Controller {
  static targets = ["modal"];

  openModal() {
    const modal = new bootstrap.Modal(this.modalTarget);
    modal.show();
  }
}
