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
end
