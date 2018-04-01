# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_with_token!, only: %i[update destroy]
      respond_to :json

      def show
        respond_with User.find(params[:id])
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: user, status: :created, location: [:api, :v1, user]
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      def update
        user = current_user

        if user.update(user_params)
          render json: user, status: :ok, location: [:api, :v1, user]
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        current_user.destroy
        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
