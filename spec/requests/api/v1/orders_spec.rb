require 'rails_helper'

describe 'Api V1 Orders', type: :request do
  let(:user)   { create(:user) }
  let!(:order) { create(:order, user: user) }
  let(:uri)    { "http://api.localhost.dev/v1/users/#{user.id}/orders/" }

  describe 'GET #index' do
    before(:each) do
      2.times { create(:order, user: user) }
      get uri, params: { user_id: user.id },
               headers: { 'Authorization': user.auth_token }
    end

    it 'returns 4 order records from the user' do
      orders_response = json_response
      expect(orders_response.size).to eq(3)
    end

    it "returns a success 200('OK') response" do
      expect(response.status).to eq(200)
    end
  end
end
