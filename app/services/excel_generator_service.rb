class ExcelGeneratorService
  attr_reader :month, :year, :trademark

  def initialize(month, year, trademark)
    @month = month
    @year = year
    @trademark = trademark
  end

  def generate_excel
    workbook = WriteXLSX.new('data.xlsx')
    @worksheet = workbook.add_worksheet

    case @trademark
    when "Remaining Volume"
      remaining_volume
    when "QC"
      qc
    end

    workbook.close
    excel_data = File.read('data.xlsx')
    excel_data
  end

  private

  def remaining_volume
    headers = [
      "Shipment", "Date Received", "Type", "State Code", "Rider No",
      "Coverage Date-From", "Coverage Date-To", "Volume"
    ]

    headers.each_with_index do |header, col|
      @worksheet.write(0, col, header)
    end

    data = RemainingVolumeService.new(@month, @year).remaining_volume_tbl

    content = []
    data&.each do |item|
      item_data = {
        shipment: item['shipment'],
        date_received: item['date_received'],
        inventory_type: item['inventory_type'],
        state_code: item['state_code'],
        rider_no: item['rider_no'],
        coverage_date_from: item['coverage_date_from'],
        coverage_date_to: item['coverage_date_to'],
        volume: item['volume']
      }
      content << item_data
    end

    content.each_with_index do |row, row_index|
      row.values.each_with_index do |value, col_index|
        @worksheet.write(row_index + 1, col_index, value)
      end
    end
  end

  def qc
    headers = [
      "Transmission Date", "Number of Filing", "Number of error Critical", "Number of error Non Critical", "Rider No",
      "Number of Score Critical", "Number of Score Non Critical", "Base", "Debtor", "Collateral"
    ]

    headers.each_with_index do |header, col|
      @worksheet.write(0, col, header)
    end

    data = QcService.new(@year, @month).fetch_score[:table]

    content = []
    data&.each do |item|
      item_data = {
        ucc_transmission_date: item['ucc_transmission_date'],
        number_of_filing: item['number_of_filing'],
        no_of_error_critical: item['no_of_error_critical'],
        no_of_error_non_critcal: item['no_of_error_non_critical'],
        quality_score_critical: string_percent(item['quality_score_critical']),
        quality_score_non_critical: string_percent(item['quality_score_non_critical']),
        base: item['base'],
        debtor: item['debtor'],
        collateral: item['collaterals'],
      }
      content << item_data
    end

    content.each_with_index do |row, row_index|
      row.values.each_with_index do |value, col_index|
        @worksheet.write(row_index + 1, col_index, value)
      end
    end
  end

  def string_percent(str)
    percent_value =str.to_f * 100
    sprintf('%.2f%%', percent_value)
  end
end
