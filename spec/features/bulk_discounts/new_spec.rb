require 'rails_helper'

RSpec.describe "Merchant New Bulk Discount" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
  end

  describe "When I visit my bulk discount index page" do
    it "I see a link to create a new discount" do
      visit merchant_bulk_discounts_path(@merchant)
      expect(page).to have_link("New Discount")
      click_on("New Discount")
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
    end
  end

  describe "After I click on the link to create a new discount" do
    it "I am taken to a form that allows me to add new discount information" do
      visit new_merchant_bulk_discount_path(@merchant)

      fill_in "Discount", with: 100
      fill_in "Quantity threshold", with: 10
      click_on "Create Bulk discount"

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))

      expect(page).to have_content(100)
      expect(page).to have_content(10)
    end
  end
end
