class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update]
  before_action :find_product, only: [:update, :destroy]
  respond_to :json
  
  def index
    respond_with Product.all
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
