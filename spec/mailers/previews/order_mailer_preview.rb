# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  def send_confirmation
    order = Order.first
    OrderMailer.send_confirmation(order)
  end
end
