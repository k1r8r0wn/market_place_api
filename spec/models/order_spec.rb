require 'rails_helper'

describe Order, type: :model do
  subject { create(:order) }
  
  describe 'respond' do
    it { should respond_to(:total) }
    it { should respond_to(:user_id) }
  end

  describe 'validation' do
    it { should validate_presence_of :user_id }
  end

  describe 'relation' do
    it { should belong_to :user }
    it { should have_many(:placements) }
    it { should have_many(:products).through(:placements) }
  end

  describe '#set_total!' do
    let(:product_1) { create(:product, price: 100) }
    let(:product_2) { create(:product, price: 85) }
    let(:order)     { build(:order, product_ids: [product_1.id, product_2.id]) }

    it 'returns the total amount to pay for the products' do
      expect{order.set_total!}.to change{order.total}.from(0).to(185)
    end
  end
end
