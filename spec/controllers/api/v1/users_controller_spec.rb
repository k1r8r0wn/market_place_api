require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @user = create(:user) 
      get :show, params: { id: @user.id }
    end

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:email]).to eql @user.email
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
        expect(json_response[:email]).to eql @user_attributes[:email]
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
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do

    before(:each) do
      @user = create(:user)
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: { id: @user.id,
                                 user: { email: 'newmail@example.com' } }
      end

      it 'renders the json representation for the updated user' do
        expect(json_response[:email]).to eql 'newmail@example.com'
      end

      it { should respond_with 200 }
    end

    context 'when is not created' do
      before(:each) do
        patch :update, params: { id: @user.id,
                                 user: { email: 'bademail.com' } }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors][:email]).to include 'is invalid'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before do
      @user = create(:user)
      delete :destroy, params: { id: @user.id }
    end

    it { should respond_with 204 }
  end
end
