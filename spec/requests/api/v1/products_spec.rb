require 'rails_helper'

describe 'Api V1 Products', type: :request do
  let(:user)   { create(:user) }
  let!(:product) { create(:product, user: user) }
  let(:uri)     { 'http://api.localhost.dev/v1/products/' }
  let(:uri_2)   { "http://api.localhost.dev/v1/products/#{product.id}" }
  let(:uri_3)   { "http://api.localhost.dev/v1/users/#{user.id}/products/" }
  let(:uri_4)   { "http://api.localhost.dev/v1/users/#{user.id}/products/#{product.id}" }

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
      get uri_2
    end

    it "returns a success 200('OK') response" do
      expect(response.status).to eq(200)
    end

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:title]).to eql product.title
    end
  end

  describe 'POST #create' do
    def create_products_request(attributes)
      post uri_3, params: { user_id: user.id, product: attributes },
                  headers: { 'Authorization' => user.auth_token }
    end

    context 'when is successfully created' do
      let(:product_attributes) { attributes_for(:product) }

      it "returns a success 201('Created') response" do
        create_products_request(product_attributes)
        expect(response.status).to eq(201)
      end

      it 'renders the json representation for the product record just created' do
        create_products_request(product_attributes)
        expect(json_response[:title]).to eql product_attributes[:title]
      end

       it 'creates product and saves it to db' do
        expect{ create_products_request(attributes_for(:product)) }.to change{ Product.count }.by(1)
      end
    end

    context 'when is not created' do
      let(:invalid_product_attributes) {{ 'title': 'Smart TV', 'price': 'Twelve dollars' }}

      it "returns a client error 422('Unprocessable Entity') response" do
        create_products_request(invalid_product_attributes)
        expect(response.status).to eq(422)
      end

      it 'renders an errors json' do
        create_products_request(invalid_product_attributes)
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        create_products_request(invalid_product_attributes)
        expect(json_response[:errors][:price]).to include 'is not a number'
      end

      it "doesn't create & save product when the 'title' field is empty" do
        post uri_3, params: { product: invalid_product_attributes }, 
                    headers: { 'Authorization' => user.auth_token }
        expect{ create_products_request(invalid_product_attributes) }.to_not change{ Product.count }
      end
    end
  end
  
  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) do
        patch uri_4, params: { user_id: user.id, id: product.id,
                               product: { title: 'An expensive TV' } },
                               headers: { 'Authorization' => user.auth_token }
      end

      it "returns a success 200('OK') response" do
        expect(response.status).to eq(200)
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:title]).to eql 'An expensive TV'
      end
    end

    context 'when is not updated' do
      before(:each) do
        patch uri_4, params: { user_id: user.id, id: product.id,
                               product: { price: 'two hundred' } },
                               headers: { 'Authorization' => user.auth_token }
      end

      it "returns a client error 422('Unprocessable Entity') response" do
        expect(response.status).to eq(422)
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:price]).to include 'is not a number'
      end
    end
  end
  
  describe 'DELETE #destroy' do
    it "returns a success 204('No Content') response" do
      delete uri_4, params: { user_id: user.id, id: product.id },
                    headers: { 'Authorization' => user.auth_token }
      expect(response.status).to eq(204)
    end

    it 'deletes product from db' do
      # p product.id
      expect{ delete uri_4, params: { user_id: user.id, id: product.id }, 
                            headers: { 'Authorization' => user.auth_token } }.to change{ Product.count }.by(-1)
    end
  end
end