import { Controller } from "@hotwired/stimulus";
import Chart from 'chart.js/auto';
import ChartDataLabels from 'chartjs-plugin-datalabels';

export default class extends Controller {
  static values = { age: Object };

  connect() {
    const labels = Object.keys(this.ageValue);
    const data = Object.values(this.ageValue);
    const ctx = document.getElementById("collateral-filing");

    const labelsCount = labels.length;
    const responsive = labelsCount <= 5 ? true : false;

    this.chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'Remaining Volume',
          data: data,
          backgroundColor: '#1775F1'
        }]
      },
      plugins: [ChartDataLabels],
      options: {
        plugins: {
          datalabels: {
            color: '#1775F1',
            anchor: 'end',
            align: 'top'
          },
          legend: {
            display: false
          },
          title: {
            display: true,
            text: 'Collateral'
          }
        },
        scales: {
          y: {
            display: false,
            beginAtZero: true,
            grid: {
              display: false,
              borderWidth: 0
            }
          },
          x: {
            grid: {
              display: false
            },
            barThickness: 50
          }
        },
        layout: {
          padding: {
            top: 20,
            bottom: 0,
            left: 0,
            right: 0
          }
        },
        responsive: responsive
      }
    });

    tthis.adjustChartDimensions(labelsCount);
  }

  adjustChartDimensions(num) {
    const ctx = document.getElementById("rm-type");
    const parentHeight = ctx.parentElement.clientHeight;
    ctx.style.height = `${parentHeight}px`;
    this.adjustChartWidth(num);
  }

  adjustChartWidth(num) {
    let width = 300;
    if (num > 5) {
      let extension = (num - 5) * 50;
      width += extension;
    }
    const ctx = document.getElementById("collateral-filing");
    ctx.style.width = `${width}px`;
  }
}
