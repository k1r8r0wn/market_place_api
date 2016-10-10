require 'rails_helper'

describe 'Api V1 Orders', type: :request do
  let(:user)   { create(:user) }
  let(:uri_1)    { "http://api.localhost.dev/v1/users/#{user.id}/orders/" }
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

  describe 'GET #create' do
    let(:product_1) { create(:product) }
    let(:product_2) { create(:product) }

    before(:each) do
      order_params = { product_ids: [product_1.id, product_2.id] }
      post uri_1, params: { user_id: user.id, order: order_params },
                  headers: { 'Authorization': user.auth_token }
    end

    it 'returns the user order record matching the id' do
      order_response = json_response[:order][:id]
      expect(order_response).to eq(1)
    end

    it "returns a success 201('Created') response" do
      expect(response.status).to eq(201)
    end
  end
end
