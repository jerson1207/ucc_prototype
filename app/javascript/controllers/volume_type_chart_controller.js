import { Controller } from "@hotwired/stimulus";
import Chart from 'chart.js/auto';
import ChartDataLabels from 'chartjs-plugin-datalabels';

export default class extends Controller {
  static values = { data: Array };

  connect() {
    const data = this.dataValue.map((item) => item.volume);
    const labels = this.dataValue.map((item) => item.type);
    const ctx = document.getElementById("rm-type");

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
              display: false,
            },
            ticks: {
              autoSkip: false
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
        responsive: responsive,
        maintainAspectRatio: false
      }
    });

    this.adjustChartDimensions(labelsCount);
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
    const ctx = document.getElementById("rm-type");
    ctx.style.width = `${width}px`;
  }
}