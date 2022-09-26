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
      expect(page).to have_content("#{@discounts[0].percentage * 100}%")
      expect(page).to have_content("#{@discounts[1].percentage * 100}%")
    end

    it 'Each bulk discount has a link to its show page' do 
      visit merchant_discounts_path(@merchant)
      click_link "#{@discounts[0].name}"
      expect(current_path).to eq(merchant_discount_path(@merchant, @discounts[0]))
    end

    it 'Next to each bulk discount there is a link to delete it' do
      visit merchant_discounts_path(@merchant)
      expect(page).to have_button 'Delete'
    end
    
    it 'When I click delete, I am redirected to the index where the discount is no longer listed' do
      visit merchant_discounts_path(@merchant)
      within "#discount-#{@discounts[0].id}" do
        click_button 'Delete'
      end
      expect(current_path).to eq(merchant_discounts_path(@merchant))
      expect(page).not_to have_content(@discounts[0].name)
      expect(page).to have_content(@discounts[1].name)
    end

    it "I see a section with the header 'Upcoming Holidays'" do
      visit merchant_discounts_path(@merchant)
      expect(page).to have_content('Upcoming Holidays')
    end
    
    it "'Upcoming Holidays' has the name and date of the next 3 US holidays" do
      visit merchant_discounts_path(@merchant)
      expect(page).to have_content('Columbus Day 2022-10-10')
      expect(page).to have_content('Thanksgiving Day 2022-11-24')
      expect(page).to have_content('Veterans Day 2022-11-11')
    end
  end
end