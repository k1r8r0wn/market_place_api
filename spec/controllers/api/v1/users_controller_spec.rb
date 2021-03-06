# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    before(:each) do
      get :show, params: { id: user.id }
    end

    it 'returns the information about a reporter on a hash' do
      user_response = json_response[:user][:email]
      expect(user_response).to eql user.email
    end

    it 'has the product ids as an embeded object' do
      user_response = json_response[:user][:product_ids]
      expect(user_response).to eql []
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @user_attributes = attributes_for(:user)
        post :create, params: { user: @user_attributes }
      end

      it 'renders the json representation for the user record just created' do
        user_response = json_response[:user][:email]
        expect(user_response).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        # Notice: not including the email here
        @invalid_user_attributes = { password: 'password',
                                     password_confirmation: 'password' }
        post :create, params: { user: @invalid_user_attributes }
      end

      it 'renders an errors json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = json_response[:errors][:email]
        expect(user_response).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      api_authorization_header user.auth_token
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: { id: user.id,
                                 user: { email: 'newmail@example.com' } }
      end

      it 'renders the json representation for the updated user' do
        user_response = json_response[:user][:email]
        expect(user_response).to eql 'newmail@example.com'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: { id: user.id,
                                 user: { email: 'bad_email.com' } }
      end

      it 'renders an errors json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be updated' do
        user_response = json_response[:errors][:email]
        expect(user_response).to include 'is invalid'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before do
      api_authorization_header user.auth_token
      delete :destroy, params: { id: user.auth_token }
    end

    it { should respond_with 204 }
  end
end
