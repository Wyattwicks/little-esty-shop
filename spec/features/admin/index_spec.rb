require 'rails_helper'

describe 'admin index page' do
  context 'when you arrive at the page' do
    it 'shows a header that you are on the admin dashboard' do
      visit "/admin"

      expect(page).to have_content("Admin Dashboard")
    end

    it 'shows links to dashboard, merchants, and invoices' do
      visit "/admin"

      expect(page).to have_link("Dashboard")
      expect(page).to have_link("Merchants")
      expect(page).to have_link("Invoices")
    end
  end

  context 'you have invoices that have some items shipped' do
    before :each do
      @invoice = create(:random_invoice)
      @invoice_2 = create(:random_invoice)
      @invoice_3 = create(:random_invoice)

      @invoice_item_1 = create(:random_invoice_item, status: 2, invoice: @invoice)
      @invoice_item_2 = create(:random_invoice_item, status: 1, invoice: @invoice_2)
      @invoice_item_3 = create(:random_invoice_item, status: 0, invoice: @invoice_3)
    end

    it 'shows all of the invoices with no items shipped' do

      visit "/admin"

      # expect(page).to_not have_content(@invoice.id)
      expect(page).to have_content(@invoice_2.id)
      expect(page).to have_content(@invoice_3.id)
    end

    it 'shows all invoices in order' do
      visit "/admin"

      expect("#{@invoice_2.id}").to appear_before("#{@invoice_3.id}")
    end
  end

  context 'you have customers with transactions' do
    before {
      @customer_1 = create(:random_customer)
      @customer_2 = create(:random_customer)
      @customer_3 = create(:random_customer)
      @customer_4 = create(:random_customer)
      @customer_5 = create(:random_customer)
      @customer_6 = create(:random_customer)

      @invoice_1 = create(:random_invoice, customer: @customer_1)
      @invoice_2 = create(:random_invoice, customer: @customer_2)
      @invoice_3 = create(:random_invoice, customer: @customer_3)
      @invoice_4 = create(:random_invoice, customer: @customer_4)
      @invoice_5 = create(:random_invoice, customer: @customer_5)
      @invoice_6 = create(:random_invoice, customer: @customer_6)
    }

    it 'shows top 5 customers' do
      transaction_1 = create(:random_transaction, result: 1, invoice: @invoice_1)
      transaction_2 = create(:random_transaction, result: 1, invoice: @invoice_2)
      transaction_3 = create(:random_transaction, result: 1, invoice: @invoice_3)
      transaction_4 = create(:random_transaction, result: 1, invoice: @invoice_4)
      transaction_5 = create(:random_transaction, result: 1, invoice: @invoice_5)
      transaction_6 = create(:random_transaction, result: 0, invoice: @invoice_6)

      visit '/admin'

      expect(page).to have_content(@customer_1.first_name + ' ' + @customer_1.last_name)
      expect(page).to have_content(@customer_2.first_name + ' ' + @customer_2.last_name)
      expect(page).to have_content(@customer_3.first_name + ' ' + @customer_3.last_name)
      expect(page).to have_content(@customer_4.first_name + ' ' + @customer_4.last_name)
      expect(page).to have_content(@customer_5.first_name + ' ' + @customer_5.last_name)
      expect(page).to_not have_content(@customer_6.first_name + ' ' + @customer_6.last_name)
    end

    it 'top customers are ordered by most transactions descending' do
      transaction_1 = create(:random_transaction, result: 1, invoice: @invoice_1)
      transaction_2 = create(:random_transaction, result: 1, invoice: @invoice_2)
      transaction_3 = create(:random_transaction, result: 1, invoice: @invoice_2)

      visit '/admin'

      expect(@customer_2.first_name + ' ' + @customer_2.last_name).to appear_before(@customer_1.first_name + ' ' + @customer_1.last_name)
    end
  end
end
