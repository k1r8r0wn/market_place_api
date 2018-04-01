# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user_password = params[:session][:password]
        user_email = params[:session][:email]
        user = user_email.present? && User.find_by(email: user_email)

        if user&.valid_password?(user_password)
          sign_in user
          user.generate_authentication_token!
          user.save
          render json: user, status: :ok, location: [:api, :v1, user]
        else
          render json: { errors: 'Invalid email or password' }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find_by(auth_token: params[:id])
        user.generate_authentication_token!
        user.save
        head :no_content
      end
    end
  end
end
