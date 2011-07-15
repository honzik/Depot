class Order < ActiveRecord::Base
  
  before_create :update_ship_date
  
	if PaymentType.find(:all).count > 0
		@@payment_type = PaymentType.find(:all).map {|p| [I18n.t('.' + p.name), p.name]}	
	else
		@@payment_type = [
		  [I18n.t('.chq'), 'chq'],
		  [I18n.t('.cc'), 'cc']
		]	
	end
	
	has_many	:line_items, :dependent => :destroy
		
	validates	:name, :address, :email, :pay_type, :presence => true
	validate :check_payment_type
	
	
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
  
  private
  
  def check_payment_type
    @@payment_type.each do |p|
		  if p[1] == pay_type
		    return
      end
    end
    errors.add(:pay_type, "Payment type of code #{pay_type} not allowed")
  end

end
