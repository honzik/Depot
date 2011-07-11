require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  fixtures :orders
  
  # Replace this with your real tests.
  test "a created order must have ship_date 1 day from now" do
    order = Order.new(orders(:one).attributes)
    order.save
    assert_equal order.ship_date, Date.tomorrow
  end
end
