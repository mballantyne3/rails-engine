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

  it 'can return an item by its specified id' do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    get "/api/v1/items/#{id}"

    item_data = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(item_data[:data]).to have_key(:id)
    expect(item_data[:data][:id]).to eq("#{id}")

    expect(item_data[:data][:attributes][:name]).to be_a(String)
    expect(item_data[:data][:attributes][:description]).to be_a(String)
    expect(item_data[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item_data[:data][:attributes][:merchant_id]).to be_a(Integer)
  end
end
