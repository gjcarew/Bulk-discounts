class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.integer :threshold
      t.float :percentage
      t.belongs_to :merchant, foreign_key: true

      t.timestamps
    end
  end
end
