class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :discount, :quantity_threshold, numericality: true
  # validates_presence_of :merchant_id

  def discount_percent
    discount_percent = BulkDiscount.discount / 100
  end
end
