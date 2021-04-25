require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it {should belong_to :customer}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many :items}
  end

  describe 'class methods' do
    describe '.where_not_successful' do
      it 'returns all the invoices where the items have not been shipped' do
        invoice = create(:random_invoice)
        invoice_2 = create(:random_invoice)
        invoice_3 = create(:random_invoice)

        invoice_item_1 = create(:random_invoice_item, status: 2, invoice: invoice)
        invoice_item_2 = create(:random_invoice_item, status: 1, invoice: invoice_2)
        invoice_item_3 = create(:random_invoice_item, status: 0, invoice: invoice_3)

        expect(Invoice.where_not_successful).to eq([invoice_2, invoice_3])

        invoice_item_4 = create(:random_invoice_item, status: 0, invoice: invoice)

        expect(Invoice.where_not_successful).to eq([invoice, invoice_2, invoice_3])
      end
    end
  end
  describe 'instance methods' do
    describe '#total_revenue' do
      it 'calculates the total revenue of a invoice' do
        invoice = create(:random_invoice)
        inv_item_1 = create(:random_invoice_item, unit_price: 20, quantity: 5, invoice: invoice)
        inv_item_2 = create(:random_invoice_item, unit_price: 100, quantity: 5, invoice: invoice)

        expect(invoice.total_revenue).to eq(600)
      end
    end

    describe '#total_revenue including bulk discounts' do
      it "calculates the total revenue including discounts" do

        merchant = create(:random_merchant, id: 22)
        item_1 = create(:random_item, id: 1, merchant_id: 22)
        customer_1 = create(:random_customer, id: 1)
        invoice_1 = create(:random_invoice, id: 1, customer_id: 1, status: 2)
        invoice_item_1 = create(:random_invoice_item, unit_price: 100, quantity: 10, invoice: invoice_1, item: item_1)
        discount_1 = create(:random_bulk_discount, discount: 100, quantity_threshold: 10, merchant_id: 22)
        # require "pry";binding.pry


        expect(invoice_1.total_revenue_with_bulk_discounts).to eq(0)
      end
    end
  end
end
