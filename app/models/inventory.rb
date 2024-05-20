class Inventory < ApplicationRecord
  has_many :inventory_item, dependent: :destroy
  # validates :filename, presence: true
end
