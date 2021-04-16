require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it {should have_many :items}
  end

  describe "validations" do
    it {should validate_presence_of :name}
  end

  describe "Instance Methods" do
    describe "#ready_to_ship" do
      it "returns items ready to ship" do
        merchant = create(:random_merchant, id: 22)
        item_1 = create(:random_item, id: 1, merchant_id: 22)
        item_2 = create(:random_item, id: 2, merchant_id: 22)
        item_3 = create(:random_item, id: 3, merchant_id: 22)
        invoice_item_1 = create(:random_invoice_item, item: item_1, status: 0)
        invoice_item_2 = create(:random_invoice_item, item: item_2, status: 1)
        invoice_item_3 = create(:random_invoice_item, item: item_3, status: 2)
        expect(merchant.ready_to_ship).to eq([item_1, item_2])
      end
    end

    describe "#favorite_customers" do
      it "returns a the first five customers with most successful transactions" do
        merchant = create(:random_merchant, id: 22)
        customer_1 = create(:random_customer)
        customer_2 = create(:random_customer)
        customer_3 = create(:random_customer)
        customer_4 = create(:random_customer)
        customer_5 = create(:random_customer)
        customer_6 = create(:random_customer)

        invoice_1 = create(:random_invoice, customer: customer_1)
        invoice_2 = create(:random_invoice, customer: customer_2)
        invoice_3 = create(:random_invoice, customer: customer_3)
        invoice_4 = create(:random_invoice, customer: customer_4)
        invoice_5 = create(:random_invoice, customer: customer_5)
        invoice_6 = create(:random_invoice, customer: customer_6)

        item_1 = create(:random_item, id: 1, merchant_id: 22)
        item_2 = create(:random_item, id: 2, merchant_id: 22)
        item_3 = create(:random_item, id: 3, merchant_id: 22)

        invoice_item_1 = create(:random_invoice_item, invoice: invoice_1, item: item_1, status: 0)
        invoice_item_2 = create(:random_invoice_item, invoice: invoice_2, item: item_2, status: 1)
        invoice_item_3 = create(:random_invoice_item, invoice: invoice_1, item: item_3, status: 2)

        transaction_1 = create(:random_transaction, result: 1, invoice: invoice_1)
        transaction_2 = create(:random_transaction, result: 1, invoice: invoice_2)
        transaction_3 = create(:random_transaction, result: 1, invoice: invoice_3)
        transaction_4 = create(:random_transaction, result: 1, invoice: invoice_4)
        transaction_5 = create(:random_transaction, result: 1, invoice: invoice_5)
        transaction_6 = create(:random_transaction, result: 0, invoice: invoice_6)

        expect(merchant.favorite_customers).to eq([
          customer_1, customer_2, customer_3, customer_4, customer_5
          ])
      end
    end
  end
end
