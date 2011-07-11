require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  fixtures :orders
  
  # Replace this with your real tests.
  test "order must have ship_date 1 day from now" do
    order = Order.new(orders(:one).attributes)
    order.save
    puts order.ship_date.to_s
  end
end
