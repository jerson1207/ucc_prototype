class DatasetsController < ApplicationController
  def inventory_files
    @inventories =InventoryItem.all
  end

  def qc_files
    @qcs = QcItem.all
  end

  
end