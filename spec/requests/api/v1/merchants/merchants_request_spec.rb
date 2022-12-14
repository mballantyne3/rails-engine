require 'rails_helper'

describe "Merchants API" do
  it "sends all merchants" do
    merchants = create_list(:merchant, 3)
    get '/api/v1/merchants'

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response_body).to match(
      { :data => [{
        :id => merchants[0].id.to_s,
        :type => "merchant",
        :attributes => {
          :name => merchants[0].name } },

        { :id => merchants[1].id.to_s,
          :type => "merchant",
          :attributes => {
            :name => merchants[1].name } },
        { :id => merchants[2].id.to_s,
          :type => "merchant",
          :attributes => {
            :name => merchants[2].name }
        }]
      }
    )
  end

  it 'returns one merchant based on id' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful
    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_response).to match(
      {
        data: { attributes: {
          name: merchant.name
        },
          id: merchant.id.to_s,
          type: 'merchant'
        }
      }
    )
  end

  it 'returns all items for a given merchant' do
    merchant = create(:merchant)
    items = create_list(:item, 2, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_response).to match data: [
      {
        attributes: {
          name: items[0].name,
          description: items[0].description,
          unit_price: items[0].unit_price,
          merchant_id: merchant.id,

        },
        id: items[0].id.to_s,
        type: 'item' },
      {
        attributes: {
          name: items[1].name,
          description: items[1].description,
          unit_price: items[1].unit_price,
          merchant_id: merchant.id,
        },
        id: items[1].id.to_s,
        type: 'item'
      },
    ]
  end

  describe 'missing merchant edge case' do
    it 'will return an error if a merchant is not found' do
      get '/api/v1/merchants/1'

      expect(response).to have_http_status(404)
      expect(response.successful?).to eq false
    end
  end

  it 'can create a new merchant' do
    merchant_params = { name: 'Mary B' }
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)
    created_merchant = Merchant.last
    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(parsed_response).to eq(
      data: {
        id: created_merchant.id.to_s,
        type: 'merchant',
        attributes: { name: 'Mary B' }
      },
    )
  end
end
