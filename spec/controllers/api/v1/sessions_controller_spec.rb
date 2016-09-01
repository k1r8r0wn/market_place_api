require 'rails_helper'

describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do

    let(:user) { create(:user) } 

    context 'when the credentials are correct' do
      before(:each) do
        credentials = { email: user.email, password: 'password' }
        post :create, params: { session: credentials }
      end

      it 'returns the user record corresponding to the given credentials' do
        user.reload
        expect(json_response[:user][:auth_token]).to eql user.auth_token
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        credentials = { email: user.email, password: 'invalidpassword' }
        post :create, params: { session: credentials }
      end

      it 'returns a json with an error' do
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) } 
    
    before(:each) do
      sign_in user 
      delete :destroy, params: { id: user.auth_token }
    end

    it { should respond_with 204 }
  end
end
