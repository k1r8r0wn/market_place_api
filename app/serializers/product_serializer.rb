class ProductSerializer < ActiveModel::Serializer
	cache key: 'product', expires_in: 30.minutes
  
  attributes :id, :title, :price, :published
  has_one :user
end
