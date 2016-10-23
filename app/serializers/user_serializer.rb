class UserSerializer < ActiveModel::Serializer
	cache key: 'user', expires_in: 30.minutes

  attributes :id, :email, :created_at, :updated_at, :auth_token, :product_ids
  has_many :products

  private

  def product_ids
    object.products.pluck(:id)
  end
end
