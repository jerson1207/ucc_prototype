class InventoryService
  UPLOADS_DIR = Rails.root.join('public', 'inventory_files')

  def self.all_data
    all_data = []

    excel_files.each do |file|
      excel = Roo::Spreadsheet.open(file)
      all_data += parse_sheet(excel)
    end

    all_data
  end

  def self.data(filename)
    file_path = File.join(UPLOADS_DIR, "#{filename}.xlsx")
    return nil unless File.exist?(file_path)
    
    excel = Roo::Spreadsheet.open(file_path)
    all_data = parse_sheet(excel)

    all_data
  end

  def self.filtered_data(year, month)
    all_data.select do |row|
      row['date_received'].year == year.to_i && row['date_received'].month == month.to_i
    end
  end

  # def self.transmitted_tbl(year, month)
  #   all_data.select do |row|
  #     next unless row['index-date'].respond_to?(:year)
  #     row['index-date'].year == year.to_i && row['index-date'].month == month.to_i
  #   end
  # end

  # def self.sum_volume
  #   total_volume = 0
  
  #   all_data.each do |data|
  #     volume = data['volume'].to_i
  #     total_volume += volume if volume
  #   end
  
  #   total_volume
  # end

  def self.volume_header
    [ "Shipment", "Date Received", "Type", "State Code", "Rider No", "Coverage Date-From",
      "Coverage Date-to", "Volume", "Index Unit", "Index Date", "Blank Party-Unit", "Blank Party-Date",
      "Colateral-unit", "Colateral-date", "Special-Unit", "Special-Date", "Tax Lien-Unit", "Tax Lien-Date",
      "Frame Scanned-Unit", "Frame Scanned-Date", "MDB-Unit", "MDB-Date", "Office Product-Unit", "Office Product-Date",
      "TAT-Index", "TAT-Blank Party", "TAT-Collateral", "TAT-Special", "TAT-Tax Lien", "TAT-MDB", "TAT-Office Product",
      "Status", "Age"]
  end

  private

  def self.excel_files
    Dir["#{UPLOADS_DIR}/*.xlsx"]
  end

  def self.parse_sheet(sheet)
    data = []
    
    (3..sheet.last_row).each do |i|
      row = sheet.row(i)
      data << {
        'shipment' => row[0],
        'date_received' => row[1],
        'type' => row[2],
        'state_code' => row[3],
        'rider_no' => row[4],
        'coverage_date-from' => row[5],
        'coverage_date-to' => row[6],
        'volume' => row[7],
        'index-unit' => row[8],
        'index-date' => row[9],
        'blank_party-unit' => row[10],
        'blank_party-date' => row[11],
        'colateral-unit' => row[12],
        'colateral-date' => row[13],
        'special-unit' => row[14],
        'special-date' => row[15],
        'tax_lien-unit' => row[16],
        'tax_lien-date' => row[17],
        'frame_scanned-unit' => row[18],
        'frame_scanned-date' => row[19],
        'mdb-unit' => row[20],
        'mdb-date' => row[21],
        'office_product-unit' => row[22],
        'office_product-date' => row[23],
        'tat-index' => row[24],
        'tat-blank_party' => row[25],
        'tat-collateral' => row[26],
        'tat-special' => row[27],
        'tat-tax_lien' => row[28],
        'tat-mdb' => row[29],
        'tat-office_product' => row[30]
      }
    end

    data.each do |row|
      row['volume_status'] = calculate_volume_status(row)
      row['days_old'] = calcuate_old_age(row)
    end

    data
  end

  def self.calculate_volume_status(row)
    date_fields = ["index-date", "blank_party-date", "colateral-date", "special-date", "tax_lien-date", "frame_scanned-date", "mdb-date", "office_product-date"]
    if date_fields.any? { |field| row[field].present? && row[field].is_a?(Date) }
      'Process'
    else
      'Remaining'
    end
  end

  def self.calcuate_old_age(row)
    (row['date_received'] - row['coverage_date-from'])
  end

end