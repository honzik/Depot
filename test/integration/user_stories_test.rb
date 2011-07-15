require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products, :orders, :users
  
  # log user :one in
  def log_user_in
    user = users(:one);        
    get "/login"  
    login_data = { 
                  :name     => user.name, 
                  :password  => 'secret'
                 }   
    post_via_redirect "/login", login_data
  end
  
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
  
  # testing login, logout success
  test "login, logout" do        
    log_user_in         
    assert_response :success            
    assert_equal '/admin', path
    
    delete_via_redirect("/logout")
    assert_response :success            
    assert_equal '/en', path         
  end
  
  # sending error on failure of orders
  test "report wrong order ID" do        
    log_user_in
    misplaced_id = 666
    
    # get index
    get_via_redirect "/orders/" + misplaced_id.to_s
    assert_response :success
    assert_template "index"
    
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["honzik@localhost"], mail.to
    assert_match /Invalid order/, mail.subject 
    assert_match /666/, mail.body.encoded
  
  end
  
  # buying a product in an empty environment
  test "update a ship date" do
    log_user_in
    order = orders(:one)
        

    # assemble path manually
    our_order_path = '/en/orders/' + order.id.to_s 
    edit_path =  our_order_path + '/edit'
    
    # manual call to edit
    get edit_path
    assert_response :success
    assert_template "edit"
    
    # order data 
    edited_order = { 
                  :name     => order.name, 
                  :address  => order.address,
                  :email    => order.email,
                  :pay_type => order.pay_type, 
                  :ship_date=> order.ship_date + 1
                  }

    # manual call to save
    put_via_redirect our_order_path, :order => edited_order    
    mail = ActionMailer::Base.deliveries.last
    assert_equal [edited_order[:email]], mail.to
    assert_match /ship date changed/, mail.subject  
    assert_match /#{Regexp.escape(edited_order[:ship_date].strftime("%A"))}/, mail.body.encoded
   
  end
  
end
