class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  enum status: [ "pending", "packaged", "shipped" ]

  def item_name
    item.name
  end

  def applied_discount
    Discount.joins(merchant: { items: :invoice_items })
            .where("invoice_items.quantity >= discounts.threshold and merchants.id = #{item.merchant_id}")
            .group(:id)
            .order(percentage: :desc)
            .limit(1)[0]    
  end
end
