class QcFilesService
  UPLOADS_DIR = Rails.root.join('public', 'qc_files')

  def self.all_data
    all_data = []
    excel_files.each do |file|
      excel = Roo::Spreadsheet.open(file)
      excel.each_with_pagename do |_sheet_name, sheet|
        all_data += parse_sheet(sheet)
      end
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

  private

  def self.excel_files
    Dir["#{UPLOADS_DIR}/*.xlsx"]
  end

  def self.parse_sheet(sheet)
    data = []

    (7..sheet.last_row).each do |i|
      row = sheet.row(i)
      data << {
        'ucc_transmission_date' => row[0],
        'number_of_filing' => row[1],
        'no_of_error_critical' => row[2],
        'no_of_error_non-critical' => row[3],
        'quality_score_critical' => row[4],
        'quality_score_non-critical' => row[5],
        'base' => row[6],
        'debtor' => row[7],
        'collaterals' => row[8]
      }
    end

    data
  end
end