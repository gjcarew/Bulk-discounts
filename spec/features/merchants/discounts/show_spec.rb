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
      expect(current_path).to eq(edit_merchant_discount(@merchant, @discount))
    end
  end

  describe 'When I visit the bulk discount edit page' do
    it 'I see a form to edit the discount pre-populated with current attributes' do
      visit edit_merchant_discount(@merchant, @discount)
      expect(page).to have_content(@discount.percentage * 100)
      expect(page).to have_content(@discount.threshold)
      expect(page).to have_content(@discount.name)
    end
    
    it 'When I change any information and click submit, I am redirected to the show page with the updated attributes' do
      visit edit_merchant_discount(@merchant, @discount)
      fill_in fill_in 'Name', with: 'Christmas discount'
      fill_in 'merchant_percentage', with: 0.58
      fill_in 'Threshold', with: 12
      click_button 'Save'
      expect(current_path).to eq(merchant_discount(@merchant, @discount))
      expect(page).to have_content('Christmas discount')
    end
  end
end

