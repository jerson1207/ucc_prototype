import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]

  connect() {
    const sidebar = document.getElementById('sidebar');
    const allSideDivider = document.querySelectorAll('#sidebar .divider');
    const storedState = localStorage.getItem("dropdownState");

    if (storedState === "true") {
      this.dropdownTarget.classList.add("show");
    }

    sidebar.addEventListener('click', (event) => {
      this.toggleSidebar(event);
    });

    sidebar.addEventListener('mouseenter', () => {
      if (sidebar.classList.contains('hide')) {
        allSideDivider.forEach(item => {
          item.textContent = item.dataset.text;
        });
      }
    });

    sidebar.addEventListener('mouseleave', () => {
      if (sidebar.classList.contains('hide')) {
        allSideDivider.forEach(item => {
          item.textContent = '-';
        });
      }
    });    
  }  

  toggleSidebar(event) {
    event.stopPropagation();

    const sidebar = document.getElementById('sidebar');
    const allSideDivider = document.querySelectorAll('#sidebar .divider');

    sidebar.classList.toggle('hide');

    if (sidebar.classList.contains('hide')) {
      allSideDivider.forEach(item => {
        item.textContent = '-';
      });
    } else {
      allSideDivider.forEach(item => {
        item.textContent = item.dataset.text;
      });
    }
  }

  dropdown(event) {
    event.preventDefault();
    const dropdown = document.getElementById('dataset-dropdown');
    dropdown.classList.toggle('show');
  }
}
