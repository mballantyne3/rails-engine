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

  it 'can create a new item' do
    merchant = create(:merchant)
    item_params = {
      name: 'Deathwish Blend',
      description: 'this will violently wake you up',
      unit_price: 24.50,
      merchant_id: merchant.id}
    headers = { "CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a String
    expect(item[:attributes][:name]).to eq("Deathwish Blend")

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a String

    expect(item[:attributes][:unit_price]).to be_a Float
    expect(item[:attributes][:unit_price]).to eq 24.50

    expect(item[:attributes][:merchant_id]).to eq(merchant.id)
  end

  it 'can update an existing item' do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id
    previous_name = Item.last.name
    item_params = {
      name: 'Get Outta Bed Blend',
      description: 'this will softly wake you up',
      unit_price: 25.50,
      merchant_id: merchant.id}
    headers = { "CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Get Outta Bed Blend")
  end
end
