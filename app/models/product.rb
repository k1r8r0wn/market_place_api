class Product < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
                    presence: true

  belongs_to :user

  scope :by_title, ->(keyword) { where('lower(title) LIKE ?', "%#{keyword.downcase}%") }
  scope :by_above_or_equal_to_price, ->(price) { where('price >= ?', price) }
  scope :by_below_or_equal_to_price, ->(price) { where('price <= ?', price) }
  scope :by_recently_updated, -> { order(:updated_at) }
end
