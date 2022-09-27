class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name
  validates :threshold, presence: true, numericality: true
  validates :percentage, presence: true, numericality: { less_than: 100 }
  validate :redundancy
  
  private

  def redundancy
    where_clause = 'discounts.percentage >= ? and discounts.threshold <= ? and merchants.id = ?'
    better_discount = Discount.joins(:merchant)
                              .where([where_clause,
                                      percentage,
                                      threshold,
                                      merchant_id])
    if !better_discount.empty?
      self.errors.add(:base, 'You have a better discount active, this discount is redundant')
    end
  end
end
