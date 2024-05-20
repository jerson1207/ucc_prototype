class Qc < ApplicationRecord
  has_many :qc_item, dependent: :destroy
end
