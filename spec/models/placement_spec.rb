require 'rails_helper'

describe Placement, type: :model do
  subject { create(:placement) }
  
  describe 'respond' do
    it { should respond_to :order_id }
    it { should respond_to :product_id }
    it { should respond_to :quantity }
  end
 
  describe 'relation' do
    it { should belong_to :order }
    it { should belong_to :product }
  end
end
