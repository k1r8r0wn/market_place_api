require 'rails_helper'

describe 'Api V1 Users', type: :request do
  let!(:user) { create(:user) }
  let(:uri)   { 'http://api.localhost.dev/v1/users/' }
  let(:uri_2) { "http://api.localhost.dev/v1/users/#{user.id}" }
  
  describe 'GET #show' do
    before(:each) do
      get uri_2
    end

    it "returns a success 200('OK') response" do
      expect(response.status).to eq(200)
    end

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:user][:email]).to eql user.email
    end
  end

  describe 'POST #create' do
    def create_user_request(attributes = @user_attributes)
      post uri, params: { user: attributes }
    end

    context 'when is successfully created' do
      before(:each) do
        @user_attributes = attributes_for(:user)
      end
      
      it "returns a success 201('Created') response" do
        create_user_request
        expect(response.status).to eq(201)
      end

      it 'renders the json representation for the user record just created' do
        create_user_request
        expect(json_response[:user][:email]).to eql @user_attributes[:email]
      end
      
      it 'creates user and saves it to db' do
        expect{ create_user_request }.to change{ User.count }.by(1)
      end
    end

    context 'when is not created' do
      before(:each) do
        # Notice: not including the email here
        @invalid_user_attributes = { password: 'password',
                                     password_confirmation: 'password' }
      end

      it "returns a client error 422('Unprocessable Entity') response" do
        create_user_request(@invalid_user_attributes)
        expect(response.status).to eq(422)
      end

      it 'renders an errors json' do
        create_user_request(@invalid_user_attributes)
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        create_user_request(@invalid_user_attributes)
        expect(json_response[:errors][:email]).to include "can't be blank"
      end

      it "doesn't create & save user when the 'email' field is empty" do
        post uri, params: { user: @invalid_user_attributes }
        expect{ create_user_request(@invalid_user_attributes) }.to_not change{ User.count }
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do
      before(:each) do
        patch uri_2, params: { user: { email: 'newmail@example.com' } }, 
                               headers: { 'Authorization' => user.auth_token }
      end

      it "returns a success 200('OK') response" do
        expect(response.status).to eq(200)
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:user][:email]).to eql 'newmail@example.com'
      end
    end

    context 'when is not updated' do
      before(:each) do
        patch uri_2, params: { user: { email: 'bademail.com' } },
                               headers: { 'Authorization' => user.auth_token }
      end

      it "returns a client error 422('Unprocessable Entity') response" do
        expect(response.status).to eq(422)
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:email]).to include 'is invalid'
      end
    end
  end

  describe 'DELETE #destroy' do
    it "returns a success 204('No Content') response" do
      delete uri_2, headers: { 'Authorization' => user.auth_token }
      expect(response.status).to eq(204)
    end

    it 'deletes user from db' do
      expect{ delete uri_2, headers: { 'Authorization' => user.auth_token } }.to change{ User.count }.by(-1)
    end
  end
end
