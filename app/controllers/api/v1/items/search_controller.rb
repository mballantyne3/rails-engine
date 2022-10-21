class Api::V1::Items::SearchController < ApplicationController

  def find_one
    # Parameter parsing
    name_search = params[:name]
    min_price = params[:min_price]&.to_i
    max_price = params[:max_price]&.to_i

    # Validation
    if name_search.present? && (min_price.present? || max_price.present?)
      render json: { error: 'that would be too many params there good human' }, status: 400 and return
    elsif min_price.present? && min_price < 0
      render json: { error: 'uhhhh... you think we are giving away items for free?' }, status: 400 and return
    elsif max_price.present? && max_price < 0
      render json: { error: 'nope, still not giving things away for free' }, status: 400 and return
    end

    # Query building
    possible_items = Item.order Arel.sql("LOWER(name)")
    possible_items.where!('name ILIKE ?', "%#{name_search}%") if name_search
    possible_items.where!('unit_price >= ?', min_price) if min_price
    possible_items.where!('unit_price <= ?', max_price) if max_price

    # Query execution
    item = possible_items.first

    # Response
    if item
      render json: ItemSerializer.new(item)
    else
      render json: { data: { message: 'No item matches your search' } }, status: 400
    end
  end
end
