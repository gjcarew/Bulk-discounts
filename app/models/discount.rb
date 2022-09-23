class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name
  validates :threshold, presence: true, numericality: true
  validates :percentage, presence: true, numericality: { less_than: 100 }
end
