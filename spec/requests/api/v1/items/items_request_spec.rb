require 'rails_helper'

RSpec.describe "Items API" do
  it 'can send a list of all items' do
    merchant = create(:merchant)
    items = create_list(:item, 15, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful
    items_response = JSON.parse(response.body, symbolize_names: true)
    expect(items_response[:data].count).to eq 15
  end
end
