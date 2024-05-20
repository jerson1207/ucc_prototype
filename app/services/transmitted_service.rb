class TransmittedService
  def initialize(year, month)
    @year = year
    @month = month
  end

  def transmittals_info
    transmittals_data = {
      index: { date: 'index_date', unit: 'index_unit', tat: 'tat_index', sla: 14 },
      blank_party: { date: 'blank_party_date', unit: 'blank_party-unit', tat: 'tat_blank_party', sla: 14 },
      collateral: { date: 'collateral_date', unit: 'collateral_unit', tat: 'tat_collateral', sla: 14 },
      special: { date: 'special_date', unit: 'special_unit', tat: 'tat_special', sla: 14 },
      tax_lien: { date: 'tax_lien_date', unit: 'tax_lien_unit', tat: 'tat_tax_lien', sla: 14 },
      mdb: { date: 'mdb_date', unit: 'mdb_unit', tat: 'tat_mdb', sla: 7 },
      office_product: { date: 'office_product_date', unit: 'office_product_unit', tat: 'tat_office_product', sla: 30 },
      frame_scanned: { date: 'frame_scanned_date', unit: 'frame_scanned_unit', tat: '', sla: 0 }
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
        sla: sla
      }
    end

    transmittals_info
  end

  private

  def transmitted_tbl(date)
    InventoryItem.select do |item|
      begin
        parsed_date = Date.strptime(item[date], '%Y-%m-%d')
        parsed_date.year == @year.to_i && parsed_date.month == @month.to_i
      rescue
        false
      end
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
      if !data[tat].to_s.empty?
        value = data[tat].to_i
        total += value
        count += 1
      end
    end
    average = count > 0 ? total.to_f / count : 0
    average.round(2)
  end
end
