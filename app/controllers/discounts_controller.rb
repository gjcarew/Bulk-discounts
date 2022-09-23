class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    if params[:merchant][:percentage].to_f.between?(1, 100)
      params[:merchant][:percentage] = params[:merchant][:percentage].to_f / 100 
    end
    new_discount = @merchant.discounts.new(new_discount_params)
    if new_discount.valid?
      new_discount.save
      redirect_to merchant_discounts_path(@merchant)
    else
      flash.now[:messages] = new_discount.errors.full_messages
      render :new
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.delete
    redirect_to merchant_discounts_path(params[:merchant_id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    if params[:discount][:percentage].to_f.between?(1, 100)
      params[:discount][:percentage] = params[:discount][:percentage].to_f / 100 
    end
    if discount.update(discount_params)
      redirect_to merchant_discount_path(discount.merchant_id, discount)
    else
      flash.now[:messages] = new_discount.errors.full_messages
      render :new
    end
  end

  private

  def new_discount_params
    params.require(:merchant).permit(:name, :percentage, :threshold)
  end
  
  def discount_params
    params.require(:discount).permit(:name, :percentage, :threshold)
  end
end
