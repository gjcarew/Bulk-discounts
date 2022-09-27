require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :threshold }
    it { should validate_presence_of :percentage }
    it { should validate_numericality_of :threshold }
    it { should validate_numericality_of :percentage }

    it 'should validate that a merchant does not have a 
      discount with a lower threshold or percentage' do
      merchant = create(:merchant)
      discount1 = merchant.discounts.create!(name: 'back to school', threshold: 10, percentage: 0.5)
      
      discount2 = Discount.new(name: 'autumn',
                               threshold: 7,
                               percentage: 0.3,
                               merchant_id: merchant.id)
      discount3 = Discount.new(name: 'fall',
                               threshold: 11,
                               percentage: 0.3,
                               merchant_id: merchant.id)
      discount4 = Discount.new(name: 'fall',
                               threshold: 4,
                               percentage: 0.7,
                               merchant_id: merchant.id)
      discount5 = Discount.new(name: 'fall',
                                threshold: 11,
                                percentage: 0.7,
                                merchant_id: merchant.id)

      expect(discount2.valid?).to be true
      expect(discount3.valid?).to be false
      expect(discount4.valid?).to be true
      expect(discount5.valid?).to be true
    end

    it 'should flash a message that the discount is redundant' do
      merchant = create(:merchant)
      discount1 = merchant.discounts.create!(name: 'back to school', threshold: 10, percentage: 0.5)
      discount2 = Discount.new(name: 'fall',
                               threshold: 11,
                               percentage: 0.3,
                               merchant_id: merchant.id)
      discount2.valid?
      expect(discount2.errors.full_messages[0]).to eq('You have a better discount active, this discount is redundant')
    end
  end
end
