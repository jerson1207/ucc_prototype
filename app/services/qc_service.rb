class QcService
  UPLOADS_DIR = Rails.root.join('public', 'qc_files')

  attr_reader :month, :year

  def initialize(year, month)
    @year = year.to_i
    @month = month.to_i
  end

  def filename_lookup
    month_name = Date::MONTHNAMES[month]
    abbreviated_month = month_name[0, 3]
    "#{abbreviated_month} #{year}"
  end

  def qc_table
    month_name = Date::MONTHNAMES[month]
    abbreviated_month = month_name[0, 3]
    target = "#{abbreviated_month} '#{year}"
    item = Qc.where("filename LIKE ?", "#{target}%")
    item.qc_item
  end

  def fetch_score
    base_filename = filename_lookup
    item = QcItem.find_by(month_year: base_filename, ucc_transmission_date: "Accuracy")
    if item.present?
      critical_percent = '%.2f%%' % (item.quality_score_critical.to_f * 100)
      non_critical_percent = '%.2f%%' % (item.quality_score_non_critical.to_f * 100)

      {
        critical: critical_percent,
        non_critical: non_critical_percent,
        table: QcItem.where(month_year: base_filename)
      }
    else
      {
      critical: "--",
      non_critical: "--",
      table: nil
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
