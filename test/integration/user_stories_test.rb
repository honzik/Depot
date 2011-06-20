require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  
  # buying a product in an empty environment
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    # get index
    get "/"
    assert_response :success
    assert_template "index"
    
    # buy a product
    xml_http_request :post, '/line_items', :product_id => ruby_book.id
    assert_response :success    
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    
    # new order prepared
    new_order = { :name     => "Honzik Maly", 
                  :address  => "Koutovice 225",
                  :email    => "honzik@localhost",
                  :pay_type => "Cheque"   }
    
    # then check out
    get "/orders/new"
    assert_response :success
    assert_template "new"
    post_via_redirect "/orders", :order => new_order
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # check if in orders
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]    
    assert_equal new_order[:name], order.name
    assert_equal new_order[:address], order.address
    assert_equal new_order[:email], order.email    
    assert_equal new_order[:pay_type], order.pay_type    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    
    # check sent mail
    mail = ActionMailer::Base.deliveries.last
    assert_equal [new_order[:email]], mail.to
    assert_equal 'rails@noreply.com', mail[:from].value
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject       
    
  end
end
