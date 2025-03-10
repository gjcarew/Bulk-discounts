require 'rails_helper'

RSpec.describe 'Merchant discount show page' do
  before :each do
    @merchant = create(:merchant)
    @discount = create(:discount, merchant_id: @merchant.id)
  end

  describe 'When I visit the bulk discount show page' do
    it 'I see the bulk discount quantity threshold and percentage discount' do
      visit merchant_discount_path(@merchant, @discount)
      expect(page).to have_content(@discount.percentage * 100)
      expect(page).to have_content(@discount.threshold)
      expect(page).to have_content(@discount.name)
    end
    
    it 'I see a link to edit the bulk discount' do
      visit merchant_discount_path(@merchant, @discount)
      click_link 'Edit'
      expect(current_path).to eq(edit_merchant_discount_path(@merchant, @discount))
    end
  end
end

