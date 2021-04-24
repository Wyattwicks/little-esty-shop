require 'rails_helper'

RSpec.describe "Merchant Discounts Index Page" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
    @discount_1 = create(:random_bulk_discount, merchant_id: 22)
    @discount_2 = create(:random_bulk_discount, merchant_id: 22)
    visit merchant_bulk_discounts_path(@merchant)
  end

  context "I visit the bulk discounts index page" do
    it "I see a list of my bulk discounts including percentage discount and quantity thresholds" do
      expect(page).to have_content(@discount_1.id)
      expect(page).to have_content(@discount_1.discount)
      expect(page).to have_content(@discount_1.quantity_threshold)

      expect(page).to have_content(@discount_2.id)
      expect(page).to have_content(@discount_2.discount)
      expect(page).to have_content(@discount_2.quantity_threshold)
    end

    it "each discount listed includes a link to its show page" do
      expect(page).to have_link("#{@discount_1.id}")
      expect(page).to have_link("#{@discount_2.id}")
      click_on("#{@discount_1.id}")
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_1))
    end
  end
end
