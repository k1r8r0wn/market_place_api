require 'rails_helper'

describe Api::V1::OrdersController, type: :controller do
  let(:user)  { create(:user) }
  let!(:order) { create(:order, user: user) }

  describe 'GET #index' do
    before(:each) do
      set_api_authorization_header user.auth_token
      2.times { create(:order, user: user) }
      get :index, params: { user_id: user.id }
    end

    it 'returns 4 order records from the user' do
      orders_response = json_response
      expect(orders_response.size).to eq(3)
    end

    it { should respond_with 200 }
  end
end
