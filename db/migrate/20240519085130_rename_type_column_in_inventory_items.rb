class RenameTypeColumnInInventoryItems < ActiveRecord::Migration[7.1]
  def change
    rename_column :inventory_items, :type, :inventory_type
  end
end
