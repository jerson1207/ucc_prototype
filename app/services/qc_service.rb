class QcService
  UPLOADS_DIR = Rails.root.join('public', 'qc_files')

  attr_reader :month, :year

  def initialize(year, month)
    @year = year
    @month = month
  end

  def filename_lookup
    month_name = Date::MONTHNAMES[month]
    abbreviated_month = month_name[0, 3]
    "#{abbreviated_month} '#{year}"
  end

  def fetch_score
    base_filename = filename_lookup
    file_path = find_matching_file(base_filename)
    
    if file_path
      read_excel_file(file_path)
    else
      {
        critical: "n/a",  
        non_critical: "n/a" 
      }
    end
  end

  private

  def find_matching_file(base_filename)
    files = Dir.glob("#{UPLOADS_DIR}/#{base_filename}*")
    files.first
  end

  def read_excel_file(file_path)
    xlsx = Roo::Excelx.new(file_path)
    last_row = xlsx.last_row
    critical_score = xlsx.cell(last_row, 5)
    non_critical_score = xlsx.cell(last_row, 6)

    crit_score = critical_score.is_a?(Float) ? '%.2f%%' % (critical_score * 100) : critical_score.to_s
    non_crit_score = non_critical_score.is_a?(Float) ? '%.2f%%' % (non_critical_score * 100) : non_critical_score.to_s
    
    {
      critical: crit_score,
      non_critical: non_crit_score 
    }
  end
end
