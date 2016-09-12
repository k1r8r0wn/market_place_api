require 'rails_helper'

describe Api::V1::OrdersController, type: :controller do
  let(:user)   { create(:user) }
  let!(:order) { create(:order, user: user) }

  describe 'GET #index' do
    before(:each) do
      set_api_authorization_header user.auth_token
      2.times { create(:order, user: user) }
      get :index, params: { user_id: user.id }
    end

    it 'returns 4 order records from the user' do
      orders_response = json_response[:orders]
      expect(orders_response.size).to eq(3)
    end

    it { should respond_with 200 }
  end

  describe 'GET #show' do
    before(:each) do
      set_api_authorization_header user.auth_token
      get :show, params: { user_id: user.id, id: order.id }
    end

    it 'returns the user order record matching the id' do
      order_response = json_response[:order][:id]
      expect(order_response).to eql order.id
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    let(:product_1) { create(:product) }
    let(:product_2) { create(:product) }

    before(:each) do
      set_api_authorization_header user.auth_token
      order_params = { product_ids: [product_1.id, product_2.id] }
      post :create, params: { user_id: user.id, order: order_params }
    end

    it 'returns the just user order record' do
      order_response = json_response[:order][:id]
      expect(order_response).to be_present
    end

    it { should respond_with 201 }
  end
end
