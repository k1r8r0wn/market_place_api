require 'rails_helper'

describe Product, type: :model do
  subject { create(:product) }

  describe 'respond' do
    it { should respond_to(:title) }
    it { should respond_to(:price) }
    it { should respond_to(:published) }
    it { should respond_to(:user_id) }

    it { should be_valid }
  end

  describe 'validation' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :user_id }
  end

  describe 'relation' do
    it { should belong_to :user }
  end
end
