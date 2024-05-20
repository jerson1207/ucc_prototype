class CreateQcs < ActiveRecord::Migration[7.1]
  def change
    create_table :qcs do |t|
      t.string :filename

      t.timestamps
    end
  end
end
