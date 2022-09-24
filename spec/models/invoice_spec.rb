require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'methods' do
    it 'customer_name' do
      customer = Customer.create!(first_name: 'Jeff', last_name: 'Bridges')
      invoice = customer.invoices.create!(status: 'in progress')
      expect(invoice.customer_name).to eq("#{customer.first_name} #{customer.last_name}")
    end

    it 'total_revenue' do
      customer = Customer.create!(first_name: 'Jeff', last_name: 'Bridges')
      invoice = customer.invoices.create!(status: 'in progress')
      merchant = Merchant.create!(name: "Stephen's Shady Store")
      item_toothpaste = merchant.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
      item_rock = merchant.items.create!(name: "Item Rock", description: "Decently cool rock", unit_price: 10000 )
      invoice.invoice_items.create!(item_id: item_toothpaste.id, 
                                    quantity: 1,
                                    unit_price: 6000,
                                    status: :pending)
      invoice.invoice_items.create!(item_id: item_rock.id,
                                    quantity: 3,
                                    unit_price: 12000,
                                    status: :shipped)
      expect(invoice.total_revenue).to eq(42000)
    end

    it '#incomplete' do
      @invoice1 = create(:invoice)
      create_list(:invoiceItem, 5, invoice_id: @invoice1.id, status: :shipped)
      @invoice2 = create(:invoice, created_at: Date.new(2019,7,18))
      create_list(:invoiceItem, 3, invoice_id: @invoice2.id, status: :pending)
      create_list(:invoiceItem, 3, invoice_id: @invoice2.id, status: :shipped)
      @invoice3 = create(:invoice, created_at: Date.new(2019,7,17))
      create_list(:invoiceItem, 5, invoice_id: @invoice3.id, status: :packaged)

      expect(Invoice.incomplete).to eq([@invoice3, @invoice2])
    end

    describe '#discounted_revenue' do
      it 'A bulk discount is eligible for all items a merchant sells' do
        merchant = create(:merchant)
        discount = create(:discount, merchant_id: merchant.id, threshold: 5, percentage: 0.5)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        invoice = create(:invoice)
        invoice_item1 = create(:invoiceItem,
                                item_id: item1.id, 
                                invoice_id: invoice.id,
                                unit_price: 1000,
                                quantity: 10)
        invoice_item2 = create(:invoiceItem,
                                item_id: item2.id, 
                                invoice_id: invoice.id,
                                unit_price: 500,
                                quantity: 20)
        expect(invoice.discounted_revenue).to eq(10000)
      end

      it 'Bulk discounts for one merchant should not affect items sold by another merchant' do
        merchant = create(:merchant)
        merchant2 = create(:merchant)
        discount = create(:discount, merchant_id: merchant.id, threshold: 5, percentage: 0.5)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        item3 = create(:item, merchant_id: merchant2.id)
        invoice = create(:invoice)
        invoice_item1 = create(:invoiceItem,
                               item_id: item1.id, 
                               invoice_id: invoice.id,
                               unit_price: 1000,
                               quantity: 10)
        invoice_item2 = create(:invoiceItem,
                               item_id: item2.id,
                               invoice_id: invoice.id,
                               unit_price: 500,
                               quantity: 20)
        invoice_item3 = create(:invoiceItem,
                               item_id: item3.id, 
                               invoice_id: invoice.id,
                               unit_price: 500,
                               quantity: 20)
        expect(invoice.discounted_revenue).to eq(20000)
      end

      it 'If an item meets the quantity threshold for multiple bulk discounts,
          only the one with the greatest percentage discount is applied' do
        merchant = create(:merchant)
        create(:discount, merchant_id: merchant.id, threshold: 5, percentage: 0.2)
        create(:discount, merchant_id: merchant.id, threshold: 7, percentage: 0.5)
        item1 = create(:item, merchant_id: merchant.id)
        invoice = create(:invoice)
        create(:invoiceItem,
               item_id: item1.id,
               invoice_id: invoice.id,
               unit_price: 1000,
               quantity: 10)
        expect(invoice.discounted_revenue).to eq(500)
      end

      it 'Bulk discounts apply only on a per-item basis' do
        merchant = create(:merchant)
        discount = create(:discount, merchant_id: merchant.id, threshold: 15, percentage: 0.5)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        invoice = create(:invoice)
        invoice_item1 = create(:invoiceItem,
                                item_id: item1.id, 
                                invoice_id: invoice.id,
                                unit_price: 1000,
                                quantity: 10)
        invoice_item2 = create(:invoiceItem,
                                item_id: item2.id, 
                                invoice_id: invoice.id,
                                unit_price: 500,
                                quantity: 20)
        expect(invoice.discounted_revenue).to eq(15000)
      end
    end
  end
end
