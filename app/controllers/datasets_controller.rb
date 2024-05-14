class DatasetsController < ApplicationController
  def inventory_files
    @inventory_files = InventoryService.all_data
  end

  def qc_files
    @qc_files = QcFilesService.all_data
  end
end