# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_with_token!, only: %i[create update]
      before_action :find_product, only: %i[update destroy]
      respond_to :json

      def index
        products = Product.search(params).page(params[:page]).per(params[:per_page])
        render json: products, meta: pagination(products, params[:per_page])
      end

      def show
        respond_with Product.find(params[:id])
      end

      def create
        @product = current_user.products.build(product_params)

        if @product.save
          render json: @product, status: :created, location: [:api, :v1, @product]
        else
          render json: { errors: @product.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: @product, status: :ok, location: [:api, :v1, @product]
        else
          render json: { errors: @product.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def product_params
        params.require(:product).permit(:title, :price, :published)
      end

      def find_product
        @product = current_user.products.find(params[:id])
      end
    end
  end
end
