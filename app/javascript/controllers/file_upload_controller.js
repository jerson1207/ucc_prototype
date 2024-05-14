import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  triggerInput(event) {
    const target = event.target;
    if (target === this.fileLabel || target === this.fileIcon) {
      event.preventDefault();
      this.fileInput.click(); 
    }
  }

  handleFileSelect(event) {
    const selectedFiles = event.target.files;

    if (selectedFiles.length > 0) {
      const form = this.element.closest("form");
      if (form) {
        form.submit();
      }
    }
  }

  connect() {
    this.fileLabel = this.element.querySelector(".file-upload-label");
    this.fileIcon = this.element.querySelector(".plus-icon");
    this.fileInput = this.element.querySelector("#file-upload-input");

    if (this.fileInput) {
      this.fileInput.addEventListener("change", this.handleFileSelect.bind(this));
    }
  }
}