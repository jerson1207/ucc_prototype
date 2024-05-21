class FilingService
  attr_reader :month, :year

  def initialize(month, year)
    @month = month
    @year = year
  end

  def index
    select_data('index_date')
  end

  def collateral
    select_data('collateral_date')
  end

  def tax_lien
    select_data('tax_lien_date')
  end

  def filing_info
    {
      "index" => { chart: calculate_average_age(index), table: index },
      "collateral" => { chart: calculate_average_age(collateral), table: collateral },
      "tax_lien" => { chart: calculate_average_age(tax_lien), table: tax_lien}
    }
  end

  private

  def select_data(date_key)
    InventoryItem.select do |item|
      begin
        parsed_date = Date.strptime(item[date_key], '%Y-%m-%d')
        parsed_date.year == @year.to_i && parsed_date.month == @month.to_i
      rescue
        false
      end
    end
  end

  def calculate_average_age(data)
    
    data.group_by { |row| row["state_code"] }.transform_values do |rows|
      old_age_values = rows.map { |row| row["days_old"].to_i }
      unless old_age_values.empty?
        average_old_age = old_age_values.sum.to_f / old_age_values.size
        average_old_age.to_i
      end
    end.sort_by { |_, avg_days_old| -avg_days_old }.to_h
  end
end
