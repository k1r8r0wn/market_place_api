require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  let(:user)    { create(:user) }
  let(:product) { create(:product, user: user) }

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
  
  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @product_attributes = attributes_for(:product)
        set_api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @product_attributes }
      end

      it 'renders the json representation for the product record just created' do
        expect(json_response[:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_product_attributes = { title: 'Smart TV', price: 'Twelve dollars' }
        set_api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @invalid_product_attributes }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end
  
  describe 'PUT/PATCH #update' do
    before(:each) do
      set_api_authorization_header user.auth_token
    end
    
    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: { user_id: user.id, id: product.id,
                                 product: { title: 'An expensive TV' } }
      end

      it 'renders the json representation for the updated [profuct]' do
        expect(json_response[:title]).to eql 'An expensive TV'
      end

      it { should respond_with 200 }
    end
    
    context 'when is not updated' do
      before(:each) do
        patch :update, params: { user_id: user.id, id: product.id,
                                 product: { price: 'two hundred' } }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end
  
  describe 'DELETE #destroy' do
    before do
      set_api_authorization_header user.auth_token
      delete :destroy, params: { user_id: user.id, id: product.id }
    end

    it { should respond_with 204 }
  end
end
