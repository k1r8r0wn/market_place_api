# frozen_string_literal: true

class User < ApplicationRecord
  before_create :generate_authentication_token!

  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :auth_token, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      break unless self.class.exists?(auth_token: auth_token)
    end
  end
end
