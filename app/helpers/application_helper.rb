module ApplicationHelper
	
	def display_date
		time = Time.now
    "#{time.strftime("%A %B %d,")} #{time.year}" 
  end
  
  def hidden_div_if(condition, attributes={}, &block)
  	if condition
  		attributes["style"] = "display: none"
	 	end
	 	content_tag("div", attributes, &block)
 	end
 	
 	def format_price(number)
 	  number_to_currency(ExchangeRate.convert_value(number))
  end
	
end
