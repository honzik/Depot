class ApplicationController < ActionController::Base
  protect_from_forgery

	private

		def current_cart
			Cart.find(session[:cart_id])
		rescue ActiveRecord::RecordNotFound
			cart = Cart.create
			session[:cart_id] = cart.id
			cart
		end
		
		# increment and return count
		def increment_count
			session[:counter] ||= 0
			session[:counter] += 1
		end		
		
		def zero_count
			session[:counter] = 0
		end
			

end
