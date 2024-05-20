class CreateQcItems < ActiveRecord::Migration[7.1]
  def change
    create_table :qc_items do |t|
      t.string :ucc_transmission_date
      t.string :number_of_filing
      t.string :no_of_error_critical
      t.string :no_of_error_non_critcal
      t.string :quality_score_critical
      t.string :quality_score_non_critical
      t.string :base
      t.string :debtor
      t.string :collaterals
      t.string :month_year
      t.references :qc, null: false, foreign_key: true

      t.timestamps
    end
  end
end
