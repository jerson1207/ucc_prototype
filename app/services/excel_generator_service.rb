class ExcelGeneratorService
  def initialize(content, headers)
    @content = content
    @headers = headers
  end

  def generate_excel
    workbook = WriteXLSX.new('data.xlsx')
    worksheet = workbook.add_worksheet
   
    @headers.each_with_index do |header, col|
      worksheet.write(0, col, header)
    end

    @content.each_with_index do |row, row_index|
      row.values.each_with_index do |value, col_index|
        worksheet.write(row_index + 1, col_index, value)
      end
    end

    workbook.close
    excel_data = File.read('data.xlsx')
    excel_data
  end

  
end