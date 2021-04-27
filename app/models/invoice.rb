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

  def total_discounts_for_eligible_items
     invoice_items.joins(:bulk_discounts)
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .group('invoice_items.item_id')
      .select("invoice_items.item_id, MAX(invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.discount / 100.0)) AS total_discount")
      .sum(&:total_discount)
  end

  def total_revenue_for_items_where_discounts_dont_apply
      invoice_items.joins(:bulk_discounts).joins(:item)
      .where('items.merchant_id = bulk_discounts.merchant_id AND invoice_items.quantity < bulk_discounts.quantity_threshold')
      .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_revenue_with_discounts
    discounts = self.total_discounts_for_eligible_items
    no_discounts = self.total_revenue_for_items_where_discounts_dont_apply
    discounts + no_discounts
  end
end
