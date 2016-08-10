require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  let(:product) { create(:product) }

  describe "GET #index" do
    before(:each) do
      3.times { create :product }
      get :index
    end

    it 'returns 3 records from the database' do
      expect(json_response.size).to eq(3)
    end

    it { should respond_with 200 }
  end
  
  describe 'GET #show' do
    before(:each) do
      get :show, params: { id: product.id }
    end

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:title]).to eql product.title
    end

    it { should respond_with 200 }
  end
end
