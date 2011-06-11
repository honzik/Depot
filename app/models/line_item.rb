class LineItem < ActiveRecord::Base
	belongs_to 	:order
	belongs_to	:product
	belongs_to 	:cart

	def total_price
		if price.nil?
			return 0
		else
			price * quantity
		end
	end
end
