require 'rails_helper'

describe Product, type: :model do
  let!(:product1) { create(:product, title: 'MacBook', price: 100) }
  let!(:product2) { create(:product, title: 'iPhone', price: 50) }
  let!(:product3) { create(:product, title: 'iPad', price: 150) }
  let!(:product4) { create(:product, title: 'MacBook Pro', price: 99) }
  
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
    it { should have_many(:placements) }
    it { should have_many(:orders).through(:placements) }
  end

  describe 'Filter .by_title' do
    context "when a 'MacBook' title pattern is sent" do
      it 'returns the 2 products matching' do
        expect(Product.by_title('MacBook').size).to eq(2)
      end

      it 'returns the products matching' do
        expect(Product.by_title('MacBook').sort).to match_array([product1, product4])
      end
    end
  end

  describe 'Filter .by_above_or_equal_to_price' do
    it 'returns the products which are above or equal to the price' do
      expect(Product.by_above_or_equal_to_price(100).sort).to match_array([product1, product3])
    end
  end

  describe 'Filter .by_below_or_equal_to_price' do
    it 'returns the products which are below or equal to the price' do
      expect(Product.by_below_or_equal_to_price(99).sort).to match_array([product2, product4])
    end
  end

  describe 'Filter .by_recently_updated' do
    before(:each) do
      # Touch some products to update them
      product2.touch
      product3.touch
    end

    it 'returns the most updated records' do
      expect(Product.by_recently_updated).to match_array([product3, product2, product4, product1])
    end
  end
  
  describe '.search' do
    context "when title 'iPhone' and '100' a min price are set" do
      it 'returns an empty array' do
        search_hash = { keyword: 'iPhone', min_price: 100 }
        expect(Product.search(search_hash)).to be_empty
      end
    end

    context "when title 'MacBook', '150' as max price, and '50' as min price are set" do
      it 'returns the product1' do
        search_hash = { keyword: 'MacBook', min_price: 50, max_price: 150 }
        expect(Product.search(search_hash)).to match_array([product1, product4]) 
      end
    end

    context 'when an empty hash is sent' do
      it 'returns all the products' do
        expect(Product.search({})).to match_array([product1, product2, product3, product4])
      end
    end

    context 'when product_ids is present' do
      it 'returns the product from the ids' do
        search_hash = { product_ids: [product1.id, product2.id]}
        expect(Product.search(search_hash)).to match_array([product1, product2])
      end
    end
  end
end
