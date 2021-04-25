require 'rails_helper'

RSpec.describe "Merchant Discount Edit Page" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
    @discount_1 = create(:random_bulk_discount, merchant_id: 22)
    visit merchant_bulk_discount_path(@merchant, @discount_1)
  end

  context "When I visit a discount show page" do
    it "I click the link to edit and am taken to a new page with a form to edit the discount" do
      expect(page).to have_link("Edit")
      click_on "Edit"
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_1)
    end

    it "I see a form to edit that is auto-completed with current attributes" do

    end
  end

end
