require 'rails_helper'

describe "Merchants API" do
  it "requests all merchants" do
    merchants = create_list(:merchant, 3)
    get '/api/v1/merchants'

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response_body).to contain_exactly(
      a_hash_including({
        id: merchants[0].id,
        name: merchants[0].name,
      }),
      a_hash_including({
        id: merchants[1].id,
        name: merchants[1].name,
      }),
      a_hash_including({
        id: merchants[2].id,
        name: merchants[2].name,
      }),
    )
  end

  it 'can return one merchant based on id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a String
  end
end
