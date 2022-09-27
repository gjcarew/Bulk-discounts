require './././spec/factories'
require 'csv'

desc 'Create discounts and export to CSV to be loaded into Heroku'
task create_discounts: :environment do
  300.times do
    new_discount = FactoryBot.build(:discount, merchant_id: Faker::Number.between(from: 1, to: 100))
    until new_discount.valid?
      new_discount = FactoryBot.build(:discount, merchant_id: Faker::Number.between(from: 1, to: 100))
    end
    new_discount.save
  end

  discounts = Discount.all;0 

  CSV.open( "#{Rails.root}/db/data/discounts.csv", 'w' ) do |csv_row|
    csv_row << discounts.first.attributes.map { |a,v| a }
    discounts.each do |s|
      csv_row << s.attributes.map { |a,v| v }
    end
  end
end