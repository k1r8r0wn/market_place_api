require 'rails_helper'

describe 'Api V1 Sessions', type: :request do
   describe 'POST #create' do
    let(:user) { create(:user) } 
    let(:uri)  { 'http://api.localhost.dev/v1/sessions/' }

    context 'when the credentials are correct' do
      before(:each) do
        credentials = { email: user.email, password: 'password' }
        post uri, params: { session: credentials }
      end

      it "returns a success 200('OK') response" do
        expect(response.status).to eq(200)
      end

      it 'returns the user record corresponding to the given credentials' do
        user.reload
        expect(json_response[:user][:auth_token]).to eql user.auth_token
      end
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        credentials = { email: user.email, password: 'invalidpassword' }
        post uri, params: { session: credentials }
      end

      it "returns a client error 422('Unprocessable Entity') response" do
        expect(response.status).to eq(422)
      end

      it 'returns a json with an error' do
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end
    end
  end
end
