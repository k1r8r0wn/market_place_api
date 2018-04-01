# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  def send_confirmation(order)
    @order = order
    @user = @order.user
    mail to: @user.email, subject: 'Order Confirmation'
  end
end
