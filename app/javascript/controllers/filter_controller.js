import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["month", "year"];

  connect() {
    this.element.addEventListener("change", this.submitForm.bind(this));
  }

  submitForm(event) {
    event.preventDefault();
    this.element.submit();
  }
}