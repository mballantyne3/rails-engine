class Api::V1::Merchants::SearchController < ApplicationController
  def find_all
    merchants = Merchant
      .where('name ILIKE ?', "%#{params[:name]}%")
      .order('name')
    if merchants
      render json: MerchantSerializer.new(merchants)
    end
  end
end
