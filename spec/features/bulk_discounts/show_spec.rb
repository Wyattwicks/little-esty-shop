require 'rails_helper'

RSpec.describe "Merchant Discount Show Page" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
    @discount_1 = create(:random_bulk_discount, discount: 50, quantity_threshold: 50, merchant_id: 22)
    @discount_2 = create(:random_bulk_discount, discount: 37, quantity_threshold: 37, merchant_id: 22)
    visit merchant_bulk_discount_path(@merchant, @discount_1)
  end

  context "I visit a bulk discount show page" do
    it "I see the discount's id, discount, and quantity threshold" do
      expect(page).to have_content(@discount_1.id)
      expect(page).to have_content(@discount_1.discount)
      expect(page).to have_content(@discount_1.quantity_threshold)
    end

    it "I do not see attributes for other discounts" do
      expect(page).to_not have_content(@discount_2.id)
      expect(page).to_not have_content(@discount_2.discount)
      expect(page).to_not have_content(@discount_2.quantity_threshold)
    end

    it "I see a link to edit the discount" do
      expect(page).to have_link("Edit")
    end
  end

end
