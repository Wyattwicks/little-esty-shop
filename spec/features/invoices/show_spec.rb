require 'rails_helper'

RSpec.describe "Merchant Invoice Show Page" do
  before :each do
    @merchant = create(:random_merchant)
    @item_1 = create(:random_item, merchant: @merchant)
    @invoice_1 = create(:random_invoice)
    @invoice_item_1 = create(:random_invoice_item, quantity: 10, unit_price: 10, status: 'pending', item: @item_1, invoice: @invoice_1)
    @discount_1 = create(:random_bulk_discount, discount: 50, quantity_threshold: 10, merchant_id: @merchant.id)

    visit merchant_invoice_path(@merchant, @invoice_1)
  end

  describe "As a visitor (/merchants/merchant_id/invoices/invoice_id)" do

    it "I see information related to that invoice index" do

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))

      within ".customer" do
        expect(page).to have_content(@invoice_1.customer.name)
      end
    end

    it "I see information of the items on the invoice" do
      within ".show-items" do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(10)
        expect(page).to have_content('$10')
        expect(page).to have_content('pending')
      end
    end

    it "I see total revenue that includes bulk discounts" do
        expect(page).to have_content('$50')
    end

    it "Next to each invoice item I see a link to the show page for the bulk discount that was applied" do
      expect(page).to have_link("Applied Discount")
      click_on('Applied Discount')
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_1))
    end

    it "I see a dropdown to update the invoice status" do

      expect(page).to have_button('Update Invoice')

      select "completed", from: 'Status'
      click_on 'Update Invoice'

      expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice_1))
      expect(page).to have_content("completed")
    end
  end
end
