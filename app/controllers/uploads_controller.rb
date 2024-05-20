class UploadsController < ApplicationController
  UPLOADS_DIR = Rails.root.join('public', 'inventory_files')
  QC_UPLOADS_DIR = Rails.root.join('public', 'qc_files')

  def index
    @inventory_files = Inventory.all
    @qc_files = Qc.all
  end

  def qc_file
    filename = params[:filename]
    format = params[:format]
    filename = "#{filename}.#{format}"
    @qc_file_data = Qc.find_by(filename: filename).qc_item
  end

  def inventory_file
    filename = params[:filename]
    format = params[:format]
    filename = "#{filename}.#{format}"
    @data = Inventory.find_by(filename: filename).inventory_item
  end

  def upload
    files = params[:files]

    if files.present? && files.all? { |f| f.original_filename.ends_with?('.xlsx') }
      files.each do |file|
        if file.respond_to?(:original_filename) && file.respond_to?(:read)
          filename = file.original_filename
          file_path = File.join(UPLOADS_DIR, filename)
  

          if File.exist?(file_path)
            flash[:error] = "File '#{filename}' already exists."
            redirect_to uploads_path
            return
          else
            File.open(file_path, 'wb') do |f|
              f.write(file.read)
            end
            inventory = Inventory.new(filename: filename)
            if inventory.save
              parse_excel(file_path, inventory)
            end

          end
        end
      end

      flash[:notice] = "Files uploaded successfully."
      redirect_to uploads_path
    else
      flash[:error] = files.present? ? "Only .xlsx extension files are valid." : "No files detected."
      redirect_to uploads_path
    end
  end

  def qc_upload
    files = params[:files]

    if files.present? && files.all? { |f| f.original_filename.ends_with?('.xlsx') }
      files.each do |file|
        if file.respond_to?(:original_filename) && file.respond_to?(:read)
          filename = file.original_filename
          file_path = File.join(QC_UPLOADS_DIR, filename)

          if File.exist?(file_path)
            flash[:error] = "File '#{filename}' already exists."
            redirect_to uploads_path
            return
          else

            File.open(file_path, 'wb') do |f|
              f.write(file.read)
            end
            qc = Qc.new(filename: filename)
            if qc.save
              qc_parse_excel(file_path, filename, qc)
            end
          end
        end
      end

      flash[:notice] = "Files uploaded successfully."
      redirect_to uploads_path
    else
      flash[:error] = files.present? ? "Only .xlsx extension files are valid." : "No files detected."
      redirect_to uploads_path
    end

  end

  def destroy_inventory_file
    filename = params[:filename]
    fileformat =  params[:format]
    filename_with_extension = "#{filename}.#{fileformat}"
    Inventory.find_by(filename: filename_with_extension).destroy
    file_path = File.join(UPLOADS_DIR, filename_with_extension)
    if File.exist?(file_path)
      File.delete(file_path)
    else
      render plain: "File not found"
    end

    redirect_to uploads_path
  end

  def destroy_qc_file
    
    filename = params[:filename]
    fileformat =  params[:format]
    filename_with_extension = "#{filename}.#{fileformat}"
    Qc.find_by(filename: filename_with_extension).destroy
    file_path = File.join(QC_UPLOADS_DIR, filename_with_extension)
    if File.exist?(file_path)
      File.delete(file_path)
    else
      render plain: "File not found"
    end

    redirect_to uploads_path
  end

  def parse_excel(file_path, inventory)
    excel = Roo::Spreadsheet.open(file_path)
    data = []
  
    (3..excel.last_row).each do |i|
      row = excel.row(i)
      inventory_item = inventory.inventory_item.create(
        shipment: row[0],
        date_received: row[1],
        inventory_type: row[2],
        state_code: row[3],
        rider_no: row[4],
        coverage_date_from: row[5],
        coverage_date_to: row[6],
        volume: row[7],
        index_unit: row[8],
        index_date: row[9],
        blank_party_unit: row[10],
        blank_party_date: row[11],
        collateral_unit: row[12],
        collateral_date: row[13],
        special_unit: row[14],
        special_date: row[15],
        tax_lien_unit: row[16],
        tax_lien_date: row[17],
        frame_scanned_unit: row[18],
        frame_scanned_date: row[19],
        mdb_unit: row[20],
        mdb_date: row[21],
        office_product_unit: row[22],
        office_product_date: row[23],
        tat_index: row[24],
        tat_blank_party: row[25],
        tat_collateral: row[26],
        tat_special: row[27],
        tat_tax_lien: row[28],
        tat_mdb: row[29],
        tat_office_product: row[30]
      )
  
      update_volume_status(inventory_item)
      update_days_old(inventory_item)

    end
  
    data
  end
  
  def update_volume_status(inventory_item)
    date_fields = ["index_date", "blank_party_date", "collateral_date", "special_date", "tax_lien_date", "frame_scanned_date", "mdb_date", "office_product_date"]
    if date_fields.any? { |field| inventory_item[field].present? && !!Date.strptime(inventory_item[field], '%Y-%m-%d') rescue false }
    inventory_item.update_column(:volume_status, 'Process')
    else
      inventory_item.update_column(:volume_status, 'Remaining')
    end
  end
  
  def update_days_old(inventory_item)
    if inventory_item.date_received && inventory_item.coverage_date_from
      inventory_item.days_old = (inventory_item.date_received - inventory_item.coverage_date_from).to_i
      inventory_item.save
    end
  end

  def qc_parse_excel(file_path, filename, qc)
    excel = Roo::Spreadsheet.open(file_path)
    data = []
  
    (7..excel.last_row).each do |i|
      row = excel.row(i)
      qc_item = qc.qc_item.create(
        ucc_transmission_date: row[0],
        number_of_filing: row[1],
        no_of_error_non_critcal: row[2],
        no_of_error_non_critcal: row[3],
        quality_score_critical: row[4],
        quality_score_non_critical: row[5],
        base: row[6],
        debtor: row[7],
        collaterals: row[8]
      )

      update_month_year(qc_item, filename)
    end

    data = []
  end

  def update_month_year(qc_item, filename)
    match_data = filename.match(/(\w{3}) '(\d{4})/)
    month = match_data[1]
    year = match_data[2]
    month_year = "#{month} #{year}"
    qc_item.update_column(:month_year, month_year)
  end
end  