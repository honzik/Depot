class StoreController < ApplicationController
  def index
  	@products = Product.all
  	@count = increment_count
  	@cart = current_cart
  end

end
