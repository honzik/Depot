class Order < ActiveRecord::Base
  
  before_create :update_ship_date
  
	if PaymentType.find(:all).count > 0
		@@payment_type = PaymentType.find(:all).map {|p| p.name}	
	else
		@@payment_type = ['Cheque', 'Credit card']	
	end
	
	has_many	:line_items, :dependent => :destroy
		
	validates	:name, :address, :email, :pay_type, :presence => true
	validates :pay_type, :inclusion => @@payment_type 
	
	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil
			line_items << item
		end
	end
	
	def self.get_payment_types
		@@payment_type	
	end

  protected
  
  def update_ship_date
    self.ship_date = Date.tomorrow
  end

end
