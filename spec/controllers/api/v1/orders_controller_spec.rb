# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::OrdersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let!(:order) { create(:order, user: user) }

    before(:each) do
      api_authorization_header user.auth_token
      get :index, params: { user_id: user.id }
    end

    it 'returns 1 order records from the user' do
      orders_response = json_response[:orders]
      expect(orders_response.size).to eq(1)
    end

    it_behaves_like 'paginated list'

    it { should respond_with 200 }
  end

  describe 'GET #show' do
    let(:product) { create(:product, user: user) }
    let(:order)   { create(:order, user: user, product_ids: [product.id]) }

    before(:each) do
      api_authorization_header user.auth_token
      get :show, params: { user_id: user.id, id: order.id }
    end

    it 'returns the user order record matching the id' do
      order_response = json_response[:order][:id]
      expect(order_response).to eql order.id
    end

    it { should respond_with 200 }

    it 'includes the total for the order' do
      order_response = json_response[:order]
      expect(order_response[:total]).to eql order.total.to_s
    end

    it 'includes the products on the order' do
      order_response = json_response[:order]
      expect(order_response[:products].count).to eq(1)
    end
  end

  describe 'POST #create' do
    let(:product_1) { create(:product) }
    let(:product_2) { create(:product) }
    let(:order)     { create(:order, user: user) }

    before(:each) do
      api_authorization_header user.auth_token
      order_params = { product_ids_and_quantities: [[product_1.id, 2], [product_2.id, 3]] }
      post :create, params: { user_id: user.id, order: order_params }
    end

    it 'returns the user order record' do
      order_response = json_response[:order][:id]
      expect(order_response).to be_present
    end

    it 'embeds the two product objects related to the order' do
      order_response = json_response[:order]
      expect(order_response[:products].size).to eql(2)
    end

    it { should respond_with 201 }
  end
end
