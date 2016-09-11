require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  let(:user)    { create(:user) }
  let(:product) { create(:product, user: user) }

  describe "GET #index" do
    before(:each) do
      3.times { create :product, user: user }
    end
    
    context 'when is not receiving any product_ids parameter' do
      before(:each) do
        get :index
      end
    
      it 'returns 3 records from the database' do
        products_response = json_response[:products]
        expect(products_response.size).to eq(3)
      end
      
      it { should respond_with 200 }

      it 'returns the user object into each product' do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end
    end

    context 'when product_ids parameter is sent' do
      before do
        get :index, params: { product_ids: user.product_ids }
      end

      it 'returns just the products that belong to the user' do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql user.email
        end
      end
    end
  end

  describe 'GET #show' do
    before(:each) do
      get :show, params: { id: product.id }
    end

    it 'returns the information about a reporter on a hash' do
      product_response = json_response[:product][:title]
      expect(product_response).to eql product.title
    end

    it { should respond_with 200 }

    it 'has the user as a embeded object' do
      product_response = json_response[:product][:user][:email]
      expect(product_response).to eql product.user.email
    end
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @product_attributes = attributes_for(:product)
        set_api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @product_attributes }
      end

      it 'renders the json representation for the product record just created' do
        product_response = json_response[:product][:title]
        expect(product_response).to eql @product_attributes[:title]
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
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        product_response = json_response[:errors][:price]
        expect(product_response).to include 'is not a number'
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
                                 product: { title: 'An expensive TV' } 
                               }
      end

      it 'renders the json representation for the updated [profuct]' do
        product_response = json_response[:product][:title]
        expect(product_response).to eql 'An expensive TV'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: { user_id: user.id, id: product.id,
                                 product: { price: 'two hundred' } 
                               }
      end

      it 'renders an errors json' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        product_response = json_response[:errors][:price]
        expect(product_response).to include 'is not a number'
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
