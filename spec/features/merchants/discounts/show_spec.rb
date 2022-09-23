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
    end
  end
end
