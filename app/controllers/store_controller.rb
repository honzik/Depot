class StoreController < ApplicationController
  skip_before_filter :authorize
  def index
  	@products = Product.all
  	@count = increment_count
  	@cart = current_cart
  end

end
