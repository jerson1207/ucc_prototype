class DashboardController < ApplicationController
  before_action :extract_year_and_month, only: [:index, :download_excel]

  def index
    @volume_data = volume_data
    @transmitted_data = transmitted_data
    @filing_data = filing_data
  end

  def download_excel
  end

  private

  def extract_year_and_month
    @year = params[:year].present? ? params[:year].to_i : Time.now.year
    @month = params[:month].present? ? params[:month].to_i : Time.now.month
  end

  def volume_data
    remaining_volume_service = RemainingVolumeService.new(@month, @year)
    remaining_volume_service.volume
  end

  def transmitted_data
    transmitted_service = TransmittedService.new(@year, @month)
    transmitted_service.transmittals_info
  end

  def filing_data
    filing_data = FilingService.new(@month, @year)
    filing_data.filing_info
  end
end
