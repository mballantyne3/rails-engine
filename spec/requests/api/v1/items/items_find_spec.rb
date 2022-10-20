require 'rails_helper'

RSpec.describe 'Find Items API' do
  it 'can find a single item that matches a case insensitive search term' do
    merchant = create(:merchant)
    item1 = Item.create!(name: "Dark Soul Blend", description: 'rich, chocolatey, soul crushing', unit_price: 16.66, merchant_id: merchant.id)
    item2 = Item.create!(name: "Saurons Dark Blend", description: 'darker than its predecessor', unit_price: 7.89, merchant_id: merchant.id)
    item3 = Item.create!(name: "Dark as my Soul Blend", description: 'darker STILL', unit_price: 7.89, merchant_id: merchant.id)

    get "/api/v1/items/find?name=dark"

    expect(response).to be_successful

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to match(
      {
        data:
          { attributes: {
            description: 'darker STILL',
            merchant_id: merchant.id,
            name: 'Dark as my Soul Blend',
            unit_price: 7.89
          },
            id: item3.id.to_s,
            type: 'item'
          }
      }
    )
  end

  describe 'sad path for item not matching a search' do
    it 'returns an error message if an item does not match a search' do
      merchant = create(:merchant)
      item1 = Item.create!(name: "Dark Soul Blend", description: 'rich, chocolatey, soul crushing', unit_price: 16.66, merchant_id: merchant.id)
      item2 = Item.create!(name: "Saurons Dark Blend", description: 'darker than its predecessor', unit_price: 7.89, merchant_id: merchant.id)
      item3 = Item.create!(name: "Dark as my Soul Blend", description: 'darker STILL', unit_price: 7.89, merchant_id: merchant.id)

      get "/api/v1/items/find?name=light"

      expect(response.successful?).to eq false
      expect(response).to have_http_status(400)
    end
  end

  describe 'price related search queries' do
    it 'can search for the first item whose price is greater than or equal to the minimum price point' do
      merchant = create(:merchant)
      item1 = Item.create!(name: "Dark Soul Blend", description: 'rich, chocolatey, soul crushing', unit_price: 3.45, merchant_id: merchant.id)
      item2 = Item.create!(name: "Saurons Dark Blend", description: 'darker than its predecessor', unit_price: 7.89, merchant_id: merchant.id)
      item3 = Item.create!(name: "Dark as my Soul Blend", description: 'darker STILL', unit_price: 5.99, merchant_id: merchant.id)

      get "/api/v1/items/find?min_price=5"

      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:data][:id].to_i).to eq item3.id
    end
    it 'can search for the first item whose price is less than or equal to the maximum price point' do
      merchant = create(:merchant)
      item1 = Item.create!(name: "Dark Soul Blend", description: 'rich, chocolatey, soul crushing', unit_price: 15.05, merchant_id: merchant.id)
      item2 = Item.create!(name: "Saurons Dark Blend", description: 'darker than its predecessor', unit_price: 20, merchant_id: merchant.id)
      item3 = Item.create!(name: "Dark as my Soul Blend", description: 'darker STILL', unit_price: 17.99, merchant_id: merchant.id)

      get "/api/v1/items/find?max_price=18"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:data][:id].to_i).to eq item3.id
    end

    it 'can allow the user to send one or more price related queries' do
      merchant = create(:merchant)
      item1 = Item.create!(name: "Dark Soul Blend", description: 'rich, chocolatey, soul crushing', unit_price: 15.05, merchant_id: merchant.id)
      item2 = Item.create!(name: "Saurons Dark Blend", description: 'darker than its predecessor', unit_price: 20, merchant_id: merchant.id)
      item3 = Item.create!(name: "Dark as my Soul Blend", description: 'darker STILL', unit_price: 18, merchant_id: merchant.id)

      get "/api/v1/items/find?max_price=17&min_price=15"

      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:data][:id].to_i).to eq item1.id
    end
  end

  describe 'price parameter sad paths' do
    it 'will return an error if name param is sent with either price parameters' do
      merchant = create(:merchant)
      item1 = Item.create!(name: "Dark Soul Blend", description: 'rich, chocolatey, soul crushing', unit_price: 15.05, merchant_id: merchant.id)
      item2 = Item.create!(name: "Saurons Dark Blend", description: 'darker than its predecessor', unit_price: 20, merchant_id: merchant.id)
      item3 = Item.create!(name: "Dark as my Soul Blend", description: 'darker STILL', unit_price: 18, merchant_id: merchant.id)

      get "/api/v1/items/find?name=dark&min_price=15"

      expect(response.successful?).to eq false
      expect(response).to have_http_status 400

      get "/api/v1/items/find?name=dark&max_price=15"

      expect(response.successful?).to eq false
      expect(response).to have_http_status 400
    end

    it 'will return an error if min_price is entered as less than zero' do
      merchant = create(:merchant)
      item1 = Item.create!(name: "Dark Soul Blend", description: 'rich, chocolatey, soul crushing', unit_price: 15.05, merchant_id: merchant.id)

      get "/api/v1/items/find?min_price=-15"

      expect(response.successful?).to eq false
      expect(response).to have_http_status 400
    end

    it 'will return an error if max_price is entered as less than zero' do
      merchant = create(:merchant)
      item1 = Item.create!(name: "Dark Soul Blend", description: 'rich, chocolatey, soul crushing', unit_price: 15.05, merchant_id: merchant.id)

      get "/api/v1/items/find?max_price=-18"

      expect(response.successful?).to eq false
      expect(response).to have_http_status 400
    end
  end
end
