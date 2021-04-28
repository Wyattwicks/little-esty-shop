class Invoice < ApplicationRecord
  belongs_to :customer

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:"in progress", :cancelled, :completed]

  def self.where_not_successful
    self.joins(:invoice_items)
        .where.not("invoice_items.status=2")
        .order(:created_at)
        .distinct
  end

  def total_revenue
    invoice_items.sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_discount_revenue
     invoice_items.joins(:bulk_discounts)
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .group('invoice_items.item_id')
      .select("invoice_items.item_id, MIN(invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.discount / 100.0)) AS total_discount")
      .distinct
      .sum(&:total_discount)
      .to_f

  end

  def total_revenue_discounts_dont_apply

    invoice_items.joins(:bulk_discounts)
      .where('invoice_items.quantity < bulk_discounts.quantity_threshold')
      .distinct
      .sum("invoice_items.unit_price * invoice_items.quantity")
      .to_f
  end

  def total_revenue_with_discounts
    discounts = self.total_discount_revenue
    no_discounts = self.total_revenue_discounts_dont_apply
    no_discounts + discounts
  end
end
