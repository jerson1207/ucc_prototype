class TransmittedService
  def initialize(year, month)
    @year = year
    @month = month
  end

  def transmittals_info
    transmittals_data = {
      'index' => { date: 'index-date', unit: 'index-unit', tat: 'tat-index', sla: 14 },
      'blank_party' => { date: 'blank_party-date', unit: 'blank_party-unit', tat: 'tat-blank_party', sla: 14 },
      'collateral' => { date: 'collateral-date', unit: 'collateral-unit', tat: 'tat-collateral', sla: 14 },
      'special' => { date: 'special-date', unit: 'special-unit', tat: 'tat-special', sla: 14 },
      'tax_lien' => { date: 'tax_lien-date', unit: 'tax_lien-unit', tat: 'tat-tax_lien', sla: 14 },
      'mdb' => { date: 'mdb-date', unit: 'mdb-unit', tat: 'tat-mdb', sla: 7 },
      'office_product' => { date: 'office_product-date', unit: 'office_product-unit', tat: 'tat-office_product', sla: 0 },
      'frame_scanned' => { date: 'frame_scanned-date', unit: 'frame_scanned-unit', tat: '', sla: 30 }
    }
    
    transmittals_info = {}

    transmittals_data.each do |title, data|
      date = data[:date]
      unit = data[:unit]
      tat = data[:tat]
      sla = data[:sla]

      table = transmitted_tbl(date)
      
      transmittals_info[title] = {
        unit: calculate_total_unit(table, unit), 
        tat: calculate_average_tat(table, tat), 
        sla: sla,
        table: table
      }
    end

    transmittals_info
  end

  private

  def transmitted_tbl(date)
    InventoryService.all_data.select do |row|
      next unless row[date].respond_to?(:year)
      row[date].year == @year.to_i && row[date].month == @month.to_i
    end
  end

  def calculate_total_unit(table, unit)
    total = 0
    table.each do |data|
      value = data[unit].to_i
      total += value if value
    end
    total
  end

  def calculate_average_tat(table, tat)
    total = 0
    count = 0
    table.each do |data|
      if data.key?(tat) && !data[tat].to_s.empty?
        value = data[tat].to_i
        total += value
        count += 1
      end
    end
    average = count > 0 ? total.to_f / count : 0
    average.round(2)
  end
end
