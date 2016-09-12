class Order < ApplicationRecord
  belongs_to :user
  before_validation :set_total!

  has_many :placements
  has_many :products, through: :placements

  validates :user_id, presence: true

  def set_total!
    self.total = products.map(&:price).sum
  end
end
