# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  subject { create(:user) }

  describe 'respond' do
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:auth_token) }

    it { should be_valid }
  end

  describe 'validation' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('example@domain.com').for(:email) }
    it { should validate_uniqueness_of(:auth_token) }
  end

  describe 'relation' do
    it { should have_many(:products).dependent(:destroy) }
    it { should have_many(:orders).dependent(:destroy) }
  end

  describe 'when email is not present' do
    before { subject.email = '' }
    it { should_not be_valid }
  end

  describe '#generate_authentication_token!' do
    it 'generates a unique token' do
      subject
      allow(Devise).to receive(:friendly_token).and_return('authentication_unique_token')
      subject.generate_authentication_token!
      expect(subject.auth_token).to eql 'authentication_unique_token'
    end

    it 'generates another token when one already has been taken' do
      existed_user = create(:user, auth_token: 'authentication_unique_token')
      subject.generate_authentication_token!
      expect(subject.auth_token).not_to eql existed_user.auth_token
    end
  end

  describe '#product assosiations' do
    let(:user) { create(:user) }

    before do
      user.save
      3.times { create(:product, user: user) }
    end

    it 'destroys the assosiated products on sself desruct' do
      products = user.products
      user.destroy
      products.each do |product|
        expect(Product.find(product)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
