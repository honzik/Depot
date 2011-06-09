module ApplicationHelper
	
	def display_date
		time = Time.now
    "#{time.strftime("%A %B %d,")} #{time.year}" 
  end
	
end
