require 'rails_helper'

RSpec.describe "Merchant Discounts Index Page" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
    @merchant_2 = create(:random_merchant, id: 14)
    @discount_1 = create(:random_bulk_discount, merchant_id: 22)
    @discount_2 = create(:random_bulk_discount, merchant_id: 22)
    @discount_3 = create(:random_bulk_discount, merchant_id: 14)
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

      expect(page).to_not have_content(@discount_3.id)
    end

    it "each discount listed includes a link to its show page" do
      expect(page).to have_link("#{@discount_1.id}")
      expect(page).to have_link("#{@discount_2.id}")
      click_on("#{@discount_1.id}")
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_1))
    end

    it "I see a section where the next 3 upcoming us holidays are listed" do
      expect(page).to have_content("Memorial Day")
      expect(page).to have_content("Independence Day")
      expect(page).to have_content("Labor Day")
      expect(page).to have_content("2021-05-31")
      expect(page).to have_content("2021-07-05")
      expect(page).to have_content("2021-09-06")
    end

    it "I see a link to create a new discount" do
      expect(page).to have_link("New Discount")
    end

    it "Next to each discount I see a link to delete it" do
      merchant_3 = create(:random_merchant, id: 25)
      discount_4 = create(:random_bulk_discount, merchant_id: 25)
      visit merchant_bulk_discounts_path(merchant_3)

      expect(page).to have_link("Delete")

      click_on "Delete"

      expect(page).to_not have_content(discount_4.id)
      expect(page).to_not have_content(discount_4.discount)
      expect(page).to_not have_content(discount_4.quantity_threshold)
    end

  end
end
