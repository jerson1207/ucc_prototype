class DashboardController < ApplicationController
  before_action :extract_year_and_month, only: [:index, :download_excel_remaining_volume]

  def index
    @volume_data = volume_data
    @transmitted_data = transmitted_data
    @filing_data = filing_data
    @default_table = default_table_data
    @qc_score = qc_score
  end

  def download_excel_remaining_volume
    content = default_table_data
    headers = InventoryService.volume_header
    if content.present?
      excel_data = ExcelGeneratorService.new(content, headers).generate_excel
      send_data excel_data, filename: "Remaining.xlsx"
    else
      render plain: "No data available for the specified year and month", status: :unprocessable_entity
    end
  end

  private

  def extract_year_and_month
    @year = params[:year]&.to_i || Time.now.year
    @month = params[:month]&.to_i || Time.now.month
  end

  def volume_data
    @volume_data ||= RemainingVolumeService.new(@month, @year).volume
  end

  def transmitted_data
    @transmitted_data ||= TransmittedService.new(@year, @month).transmittals_info
  end

  def filing_data
    @filing_data ||= FilingService.new(@month, @year).filing_info
  end

  def default_table_data
    @default_table_data ||= InventoryService.filtered_data(@year, @month)
  end

  def qc_score
    @qc_score ||= QcService.new(@year, @month).fetch_score
  end
end
