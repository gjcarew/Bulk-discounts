require 'rails_helper'

RSpec.describe 'Discount edit' do
  describe 'When I visit the bulk discount edit page' do
    before :each do
      @merchant = create(:merchant)
      @discount = create(:discount, merchant_id: @merchant.id)
    end

    it 'I see a form to edit the discount pre-populated with current attributes' do
      visit edit_merchant_discount_path(@merchant, @discount)
      expect(page).to have_content(@discount.percentage * 100)
      expect(page).to have_content(@discount.threshold)
      expect(page).to have_content(@discount.name)
    end
    
    it 'When I change any information and click submit, I am redirected to the show page with the updated attributes' do
      visit edit_merchant_discount_path(@merchant, @discount)
      fill_in fill_in 'Name', with: 'Christmas discount'
      fill_in 'merchant_percentage', with: 0.58
      fill_in 'Threshold', with: 12
      click_button 'Save'
      expect(current_path).to eq(merchant_discount_path(@merchant, @discount))
      expect(page).to have_content('Christmas discount')
    end
  end
end