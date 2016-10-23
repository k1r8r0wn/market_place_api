require 'rails_helper'

describe 'Api V1 Orders', type: :request do
  let(:user)   { create(:user) }
  let(:uri_1)  { "http://api.localhost.dev/v1/users/#{user.id}/orders/" }
  let(:uri_2)  { "http://api.localhost.dev/v1/users/#{user.id}/orders/#{order.id}" }

  describe 'GET #index' do
    let!(:order) { create(:order, user: user) }

    before(:each) do
      get uri_1, params: { user_id: user.id },
                 headers: { 'Authorization': user.auth_token }
    end

    it 'returns 2 order records from the user' do
      orders_response = json_response[:orders]
      expect(orders_response.size).to eq(1)
    end

    it "returns a success 200('OK') response" do
      expect(response.status).to eq(200)
    end

    it { expect(json_response).to have_key(:meta) }
    it { expect(json_response[:meta]).to have_key(:pagination) }
    it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }
  end

  describe 'GET #show' do
    let(:product) { create(:product, user: user) }
    let(:order)   { create(:order, user: user, product_ids: [product.id]) }

    before(:each) do
      get uri_2, params: { user_id: user.id, id: order.id },
                 headers: { 'Authorization': user.auth_token }
    end

    it 'returns the user order record matching the id' do
      order_response = json_response[:order][:id]
      expect(order_response).to eql order.id
    end

    it "returns a success 200('OK') response" do
      expect(response.status).to eq(200)
    end

    it "includes the total for the order" do
      order_response = json_response[:order]
      expect(order_response[:total]).to eql order.total.to_s
    end

    it "includes the products on the order" do
      order_response = json_response[:order]
      expect(order_response[:products].count).to eq(1)
    end
  end

  # TODO: Fix later

  # describe 'POST #create' do
  #   let(:product_1) { create(:product) }
  #   let(:product_2) { create(:product) }
  #   let(:order)     { create(:order, user: user) }

  #   before(:each) do
  #     order_params = { product_ids_and_quantities: [[product_1.id, 1], [product_2.id, 2]] }
  #     post uri_1, params: { user_id: user.id, order: order_params },
  #                 headers: { 'Authorization': user.auth_token }
  #   end

  #   it 'returns the user order record' do
  #     order_response = json_response[:order][:id]
  #     expect(order_response).to be_present
  #   end

  #   it "embeds the two product objects related to the order" do
  #     order_response = json_response[:order]
  #     expect(order_response[:products].size).to eql(2)
  #   end

  #   it "returns a success 201('Created') response" do
  #     expect(response.status).to eq(201)
  #   end
  # end
end
