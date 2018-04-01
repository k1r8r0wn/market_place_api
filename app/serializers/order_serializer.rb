# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  cache key: 'order', expires_in: 30.minutes

  attributes :id, :total

  has_many :products, serializer: OrderProductSerializer
end
