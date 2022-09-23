require 'rails_helper'

RSpec.describe 'Merchants discount index' do
  describe 'As a merchant, on the bulk discounts index page' do
    before :each do 
      @merchant = create(:merchant)
      @discounts = create_list(:discount, 2, merchant_id: @merchant.id)

      @sad_discount = create(:discount)
    end

    it 'I see a list of all my bulk discounts' do
      visit merchant_discounts_path(@merchant)
      expect(page).to have_content(@discounts[0].name)
      expect(page).to have_content(@discounts[1].name)
      expect(page).not_to have_content(@sad_discount.name)
    end

    it 'I see the percentage discount and quantity threshold' do
      visit merchant_discounts_path(@merchant)
      expect(page).to have_content(@discounts[0].threshold)
      expect(page).to have_content(@discounts[1].threshold)
      expect(page).to have_content(@discounts[0].percentage)
      expect(page).to have_content(@discounts[1].percentage)
    end

    it 'Each bulk discount has a link to its show page' do 
      visit merchant_discounts_path(@merchant)
      click_link "#{@discounts[0].name}"
      expect(current_path).to eq(merchant_discount_path(@merchant, @discounts[0]))
    end
  end
end