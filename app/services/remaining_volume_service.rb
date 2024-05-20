class RemainingVolumeService
  attr_reader :month, :year

  def initialize(month, year)
    @month = month
    @year = year
  end 

  def volume
    {
      volume: total_volume(filtered_data),
      remaining_volume: remaining_volume(filtered_data),
      remaining_volume_tbl_grouped_by_statecode: group_and_sum(remaining_volume_tbl, 'state_code'),
      remaining_volume_tbl_grouped_by_type: group_and_sum(remaining_volume_tbl, 'inventory_type')
    }
  end


  def group_and_sum(data, key)
    data.group_by { |entry| entry[key] }
      .map { |type, entries| { inventory_type: type, volume: total_volume(entries) } }
      .sort_by { |entry| -entry[:volume] }
  end

  def remaining_volume(data)
    data.select { |entry| entry.volume_status == 'Remaining' }
      .sum { |entry| entry.volume.to_i }
  end

  def total_volume(data)
    data.sum { |entry| entry.volume }
  end

  def filtered_data 
    InventoryItem.select do |item|
      item.date_received.year == @year.to_i && item.date_received.month == @month.to_i
    end
  end

  def remaining_volume_tbl
    filtered_data.select { |entry| entry.volume_status == 'Remaining' }
  end
end
