module DashboardHelper
  def transmitted_content(data, title)
    container = []
  
    data&.each do |item|
      item_data = {
        date_transmitted: item["#{title}_date"],
        units: item["#{title}_unit"],
        tat: item["tat_#{title}"],
        state_code: item["state_code"],
        date_received: item["date_received"],
        rider_no: item["rider_no"],
        coverage_date_from: item["coverage_date_from"],
        coverage_date_to: item["coverage_date_to"],
        volume: item["volume"]
      }
      container << item_data
    end
  
    container
  end

  def transmitted_header
    [
      "Date Transmitted", "Units", "TAT", "State Code", "Date Received", "Rider No",
      "Coverage Date-From", "Coverage Date-to", "No of Filings"
    ]
  end


  def remaining_volume_content(data)
    container = []
  
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
      container << item_data
    end
  
    container
  end

  def remaining_volume_header
    [
      "Shipment", "Date Received", "Type", "State Code", "Rider No",
      "Coverage Date-From", "Coverage Date-to", "Volume"
    ]
  end
end
