# frozen_string_literal: true

class OrderProductSerializer < ActiveModel::Serializer
  def include_user?
    false
  end
end
