class RemainingVolumeService
  attr_reader :month, :year

  def initialize(month, year)
    @month = month
    @year = year
  end

  def filtered_data
    InventoryService.filtered_data(@year, @month)
  end

  def total_volume(data)
    data.sum { |entry| entry['volume'].to_i }
  end

  def remaining_volume(data)
    data.select { |entry| entry['volume_status'] == 'Remaining' }
        .sum { |entry| entry['volume'].to_i }
  end

  def group_and_sum(data, key)
    data.group_by { |entry| entry[key] }
        .map { |type, entries| { type: type, volume: total_volume(entries) } }
        .sort_by { |entry| -entry[:volume] }
  end

  def volume
    {
      volume: total_volume(filtered_data),
      remaining_volume: remaining_volume(filtered_data),
      remaining_volume_tbl_grouped_by_statecode: group_and_sum(remaining_volume_tbl, 'state_code'),
      remaining_volume_tbl_grouped_by_type: group_and_sum(remaining_volume_tbl, 'type')
    }
  end

  private

  def remaining_volume_tbl
    filtered_data.select { |entry| entry['volume_status'] == 'Remaining' }
  end
end
