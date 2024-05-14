module UploadsHelper
  def filename_without_extension(file)
    File.basename(file, File.extname(file))
  end
end
