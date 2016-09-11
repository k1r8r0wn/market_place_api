require 'rails_helper'

describe Order, type: :model do
  subject { create(:order) }
  
  describe 'respond' do
    it { should respond_to(:total) }
    it { should respond_to(:user_id) }
  end

  describe 'validation' do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :total}
    it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }
  end

  describe 'relation' do
    it { should belong_to :user }
    it { should have_many(:placements) }
    it { should have_many(:products).through(:placements) }
  end
end
