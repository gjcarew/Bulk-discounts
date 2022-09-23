require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Create' do 
  before :each do
    @merchant = create(:merchant)
  end
  it 'There is a link to create a new discount on the bulk discount index' do
    visit merchant_discounts_path(@merchant)
    click_link 'Create a new discount'
    expect(current_path).to eq(new_merchant_discount_path(@merchant))
  end

  describe 'Happy path' do
    it 'When I fill in the form with valid data I am redirected to bulk discount index' do
      visit new_merchant_discount_path(@merchant)
      fill_in :name, with: 'Christmas discount'
      fill_in :percentage, with: .58
      fill_in :threshold, with: 12
      click_button 'Submit'
      expect(current_path).to eq(merchant_discounts_path(@merchant))
      expect(page).to have_content('Christmas discount')
    end
  end

  describe 'Sad path' do
    it 'When I fill in the form with invalid data, an error method flashes' do
      visit new_merchant_discount_path(@merchant)
      fill_in :name, with: 'Christmas discount'
      fill_in :percentage, with: 150
      fill_in :threshold, with: 14
      click_button 'Submit'
      expect(current_path).to eq(new_merchant_discount_path(@merchant))
      expect(page).to have_content('Error: invalid data')
    end
  end
end