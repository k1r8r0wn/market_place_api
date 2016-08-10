class Api::V1::ProductsController < ApplicationController
  respond_to :json

  def index
    respond_with Product.all
    # p @response
  end

  def show
    respond_with Product.find(params[:id])
  end
end
