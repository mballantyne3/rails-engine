class Api::V1::Items::SearchController < ApplicationController

  def find_one
    item = Item
      .where('name ILIKE ?', "%#{params[:name]}%") #todo: .downcase
      .order(Arel.sql("LOWER(name)"))
      .first

    if item
      render json: ItemSerializer.new(item)
    else
      render json: { data: {message: 'No item matches your search'}}, status: 400
    end
  end
end
