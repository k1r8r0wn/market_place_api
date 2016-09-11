class Product < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
                    presence: true

  belongs_to :user

  scope :by_title, ->(keyword) { where('lower(title) LIKE ?', "%#{keyword.downcase}%") }
  scope :by_above_or_equal_to_price, ->(price) { where('price >= ?', price) }
  scope :by_below_or_equal_to_price, ->(price) { where('price <= ?', price) }
  scope :by_recently_updated, -> { order(:updated_at) }

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all

    products = products.by_title(params[:keyword]) if params[:keyword]
    products = products.by_above_or_equal_to_price(params[:min_price].to_f) if params[:min_price]
    products = products.by_below_or_equal_to_price(params[:max_price].to_f) if params[:max_price]
    products = products.by_recently_updated(params[:recent]) if params[:recent].present?

    products
  end
end
