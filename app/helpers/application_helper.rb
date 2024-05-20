module ApplicationHelper
  def format_with_commas(number)
    number.to_s.reverse.scan(/\d{1,3}/).join(',').reverse
  end

  def string_percent(str)
    percent_value =str.to_f * 100
    sprintf('%.2f%%', percent_value)
  end
end
