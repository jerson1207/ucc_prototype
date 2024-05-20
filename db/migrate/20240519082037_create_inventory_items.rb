class CreateInventoryItems < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_items do |t|
      t.string :shipment
      t.date :date_received
      t.string :type
      t.string :state_code
      t.string :rider_no
      t.date :coverage_date_from
      t.date :coverage_date_to
      t.integer :volume
      t.string :index_unit
      t.string :index_date
      t.string :blank_party_unit
      t.string :blank_party_date
      t.string :collateral_unit
      t.string :collateral_date
      t.string :special_unit
      t.string :special_date
      t.string :tax_lien_unit
      t.string :tax_lien_date
      t.string :frame_scanned_unit
      t.string :frame_scanned_date
      t.string :mdb_unit
      t.string :mdb_date
      t.string :office_product_unit
      t.string :office_product_date
      t.string :tat_index
      t.string :tat_blank_party
      t.string :tat_collateral
      t.string :tat_special
      t.string :tat_tax_lien
      t.string :tat_mdb
      t.string :tat_office_product
      t.string :volume_status
      t.integer :days_old
      t.references :inventory, null: false, foreign_key: true

      t.timestamps
    end
  end
end
