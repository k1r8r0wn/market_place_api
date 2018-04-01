# frozen_string_literal: true

require 'rails_helper'

describe OrderMailer, type: :mailer do
  include Rails.application.routes.url_helpers

  describe '.send_confirmation' do
    let(:order) { create(:order) }

    before(:each) do
      @user = order.user
      @order_mailer = OrderMailer.send_confirmation(order)
    end

    it 'should be set to be delivered to the user from the order passed in' do
      expect(@order_mailer).to deliver_to(@user.email)
    end

    it 'should be set to be send from no-reply@marketplace.com' do
      expect(@order_mailer).to deliver_from('no-reply@marketplace.com')
    end

    it "should contain the user's message in the mail body" do
      expect(@order_mailer).to have_body_text(/Order: ##{order.id}/)
    end

    it 'should have the correct subject' do
      expect(@order_mailer).to have_subject(/Order Confirmation/)
    end

    it 'should have the products count' do
      expect(@order_mailer).to have_body_text(/You ordered #{order.products.count} products:/)
    end
  end
end
