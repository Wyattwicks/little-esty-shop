require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :items}
    it {should have_many :invoice_items}
    it {should have_many :invoices}
  end

  describe "validations" do
    it {should validate_presence_of :merchant_id}
    it {should validate_numericality_of :quantity_threshold}
    it {should validate_numericality_of :discount}
  end

end
