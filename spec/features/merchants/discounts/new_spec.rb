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
      fill_in 'Name', with: 'Christmas discount'
      fill_in 'merchant_percentage', with: 0.58
      fill_in 'Threshold', with: 12
      click_button 'Submit'
      expect(current_path).to eq(merchant_discounts_path(@merchant))
      expect(page).to have_content('Christmas discount')
    end
  end

  describe 'Sad path' do
    it 'When I fill in the form with invalid data, an error method flashes' do
      visit new_merchant_discount_path(@merchant)
      fill_in 'Name', with: 'Christmas discount'
      fill_in 'merchant_percentage', with: 150
      fill_in 'Threshold', with: 14
      click_button 'Submit'
      expect(page).to have_content('Percentage must be less than 100')
      fill_in 'Name', with: 'Christmas discount'
      fill_in 'merchant_percentage', with: 15
      fill_in 'Threshold', with: 14
      click_button 'Submit'
      expect(current_path).to eq(merchant_discounts_path(@merchant))
      expect(page).to have_content('Christmas discount')
    end
  end
end