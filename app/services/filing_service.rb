class FilingService
  attr_reader :month, :year

  def initialize(month, year)
    @month = month
    @year = year
  end

  def index
    select_data('index-date')
  end

  def collateral
    select_data('collateral-date')
  end

  def tax_lien
    select_data('tax_lien-date')
  end

  def filing_info
    {
      "index" => { chart: calculate_average_age(index), table: index },
      "collateral" => { chart: calculate_average_age(collateral), table: collateral },
      "tax_lien" => { chart: calculate_average_age(tax_lien), table: tax_lien }
    }
  end

  private

  def select_data(date_key)
    InventoryService.all_data.select do |row|
      next unless row[date_key].respond_to?(:year)
      row[date_key].year == year && row[date_key].month == month
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
