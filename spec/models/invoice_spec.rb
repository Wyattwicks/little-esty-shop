require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it {should belong_to :customer}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many :items}
    it {should have_many :merchants}
    it {should have_many :bulk_discounts}
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

    describe '#total_discounts_for_eligible_items' do
      it 'returns revenue of all items with a discount' do
        merchant_1 = create(:random_merchant, id: 22)
        merchant_2 = create(:random_merchant, id: 14)
        item_1 = create(:random_item, merchant_id: 22)
        item_2 = create(:random_item, merchant_id: 14)
        invoice_1 = create(:random_invoice)
        invoice_item_1 = create(:random_invoice_item, quantity: 10, unit_price: 10, status: 'pending', item: item_1, invoice: invoice_1)
        invoice_item_2 = create(:random_invoice_item, quantity: 1, unit_price: 100, status: 'pending', item: item_2, invoice: invoice_1)
        discount_1 = create(:random_bulk_discount, discount: 50, quantity_threshold: 10, merchant_id: 22)

        expect(invoice_1.total_discounts_for_eligible_items).to eq(50)
      end
    end

    describe '#total_revenue_for_items_where_discounts_dont_apply' do
      it 'returns revenue of all items where a discount does not apply' do
        merchant_1 = create(:random_merchant, id: 22)
        merchant_2 = create(:random_merchant, id: 14)
        item_1 = create(:random_item, merchant_id: 22)
        item_2 = create(:random_item, merchant_id: 14)
        invoice_1 = create(:random_invoice)
        invoice_item_1 = create(:random_invoice_item, quantity: 10, unit_price: 10, status: 'pending', item: item_1, invoice: invoice_1)
        invoice_item_2 = create(:random_invoice_item, quantity: 1, unit_price: 100, status: 'pending', item: item_2, invoice: invoice_1)
        discount_1 = create(:random_bulk_discount, discount: 50, quantity_threshold: 10, merchant_id: 22)
        discount_2 = create(:random_bulk_discount, discount: 50, quantity_threshold: 10, merchant_id: 14)

        expect(invoice_1.total_revenue_for_items_where_discounts_dont_apply).to eq(100)
      end
    end

    describe '#total_revenue_with_discounts' do
      it 'returns revenue of all items on an invoice with discounts included' do
        merchant_1 = create(:random_merchant, id: 22)
        merchant_2 = create(:random_merchant, id: 14)
        item_1 = create(:random_item, merchant_id: 22)
        item_2 = create(:random_item, merchant_id: 14)
        item_3 = create(:random_item, merchant_id: 14)
        item_4 = create(:random_item, merchant_id: 22)
        invoice_1 = create(:random_invoice)
        invoice_item_1 = create(:random_invoice_item, quantity: 10, unit_price: 10, status: 'pending', item: item_1, invoice: invoice_1)
        invoice_item_2 = create(:random_invoice_item, quantity: 1, unit_price: 100, status: 'pending', item: item_2, invoice: invoice_1)
        invoice_item_3 = create(:random_invoice_item, quantity: 10, unit_price: 10, status: 'pending', item: item_3, invoice: invoice_1)
        invoice_item_3 = create(:random_invoice_item, quantity: 1, unit_price: 100, status: 'pending', item: item_4, invoice: invoice_1)
        discount_1 = create(:random_bulk_discount, discount: 50, quantity_threshold: 10, merchant_id: 22)
        discount_2 = create(:random_bulk_discount, discount: 50, quantity_threshold: 10, merchant_id: 14)

        expect(invoice_1.total_revenue_with_discounts).to eq(300)
      end
    end
  end
end
