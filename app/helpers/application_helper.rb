module ApplicationHelper
  def format_with_commas(number)
    number.to_s.reverse.scan(/\d{1,3}/).join(',').reverse
  end
end
