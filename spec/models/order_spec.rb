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

  describe "#build_placements_with_product_ids_and_quantities" do
    let(:product_1) { create(:product, price: 100, quantity: 5) }
    let(:product_2) { create(:product, price: 85, quantity: 10) }
    let(:order)     { create(:order) }
    
    before(:each) do
      @product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]
    end

    it "builds 2 placements for the order" do
      expect{order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities)}.to change{order.placements.size}.from(0).to(2)
    end
  end

  describe '#valid?' do
    let(:product_1)   { create(:product, price: 100, quantity: 5) }
    let(:product_2)   { create(:product, price: 85, quantity: 10) }
    let(:placement_1) { build(:placement, product: product_1, quantity: 3) }
    let(:placement_2) { build(:placement, product: product_2, quantity: 15) }
    let(:order)       { create(:order) }
      
    before do
      order.placements << placement_1
      order.placements << placement_2
    end

    it 'becomes invalid due to insufficient products' do
      expect(order).to_not be_valid
    end
  end
end
