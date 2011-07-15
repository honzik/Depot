class StoreController < ApplicationController
  skip_before_filter :authorize
  def index 
    if params[:set_locale]
      redirect_to store_path(:locale => params[:set_locale])
    else
      @products = Product.find_all_by_locale(I18n.locale)
    	@count = increment_count
    	@cart = current_cart
  	end
  end
end
