class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.find_by_id(params[:id]).present?
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render status: 404
    end
  end

  def create
    merchant = Merchant.create!(merchant_params)
    render json: MerchantSerializer.new(merchant)
  end

  def update
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
