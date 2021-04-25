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

  def total_revenue_with_bulk_discounts
    # Invoice.joins(:bulk_discounts)
    #   .where("bulk_discounts.quantity_threshold = invoice_items.quantity")
    #   .sum("(invoice_items.unit_price * invoice_items.quantity) * (bulk_discounts.discount/100)")

    require "pry";binding.pry
  end
end
