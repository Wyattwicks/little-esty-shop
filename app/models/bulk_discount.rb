class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :discount, :quantity_threshold, numericality: true
  validates_presence_of :merchant_id
end
