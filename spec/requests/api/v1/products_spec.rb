require 'rails_helper'

describe 'Api V1 Products', type: :request do
  let!(:product) { create(:product) }
  let(:uri) { 'http://api.localhost.dev/v1/products/' }

  describe 'GET #index' do
    before(:each) do
      2.times { create(:product) }
      get uri
    end

    it "returns a success 200('OK') response" do
      expect(response.status).to eq(200)
    end

    it 'returns 3 records from the database' do
      expect(json_response.size).to eq(3)
    end
  end

  describe 'GET #show' do
    before(:each) do
      get uri + "#{product.id}"
    end

    it "returns a success 200('OK') response" do
      expect(response.status).to eq(200)
    end

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:title]).to eql product.title
    end
  end
end
