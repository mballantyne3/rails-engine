require 'rails_helper'

RSpec.describe 'Find Merchants API' do
  it 'can find all merchants that match a search term and returns an array even if none are found' do
    mary = Merchant.create!(name: 'Mary')
    frodo = Merchant.create!(name: 'Frodo')
    marylnn = Merchant.create!(name: 'marylynn')

    get "/api/v1/merchants/find_all?name=mary"

    expect(response).to be_successful

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_response[:data]).to be_an Array
    expect(parsed_response[:data].count).to eq 2

    parsed_response[:data].each do |merchant|
      expect(merchant[:attributes][:name]).to_not include(frodo.name)
    end
  end
end
