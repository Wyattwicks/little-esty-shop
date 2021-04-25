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
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_1))
    end

    it "I see a form to edit that is auto-completed with current attributes" do
      visit edit_merchant_bulk_discount_path(@merchant, @discount_1)
      expect(find_field('Discount').value).to have_content(@discount_1.discount)
      expect(find_field('Quantity threshold').value).to have_content(@discount_1.quantity_threshold)
    end

    it "When I edit the attributes and click submit, I am redirected back to the show page of the discount with the new info" do
      visit edit_merchant_bulk_discount_path(@merchant, @discount_1)
      fill_in 'Discount', with: 48
      fill_in 'Quantity threshold', with: 300
      click_on 'Update Bulk discount'
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_1))
      expect(page).to have_content(48)
      expect(page).to have_content(300)
    end
  end

end
