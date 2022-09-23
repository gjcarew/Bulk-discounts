class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    if params[:merchant][:percentage].to_f.between?(1, 100)
      params[:merchant][:percentage] = params[:merchant][:percentage].to_f / 100 
    end
    new_discount = @merchant.discounts.new(discount_params)
    if new_discount.valid?
      new_discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash.now[:messages] = new_discount.errors.full_messages
      render :new
    end
  end

  private

  def discount_params
    params.require(:merchant).permit(:name, :percentage, :threshold)
  end
end
