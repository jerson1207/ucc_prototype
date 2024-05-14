class UploadsController < ApplicationController
  UPLOADS_DIR = Rails.root.join('public', 'inventory_files')
  QC_UPLOADS_DIR = Rails.root.join('public', 'qc_files')

  def index
    @files = Dir.entries(UPLOADS_DIR).reject { |f| File.directory?(File.join(UPLOADS_DIR, f)) }
    @qc_datasets = Dir.entries(QC_UPLOADS_DIR).reject { |f| File.directory?(File.join(QC_UPLOADS_DIR, f)) }
  end

  def qc_file
    @qc_filename = params[:filename]
    @qc_file_data = QcFilesService.data(@qc_filename)
  end

  def inventory_file
    @filename = params[:filename]
    @data = InventoryService.data(@filename)
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
    file_path = File.join(QC_UPLOADS_DIR, filename_with_extension)

    if File.exist?(file_path)
      File.delete(file_path)
    else
      render plain: "File not found"
    end

    redirect_to uploads_path
  end
end