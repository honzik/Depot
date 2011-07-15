class Product < ActiveRecord::Base
	default_scope	:order => 'title'
	has_many	:line_items
	has_many	:orders, :through => :line_items
	before_destroy :ensure_not_referenced_by_any_line_item
		
	validates :title, :description, :image_url, :presence => true
	validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
	validates :title, :uniqueness => true
	validates	:title, :length => {:minimum => 10} 
	validates :image_url, :format => {
		:with 		=> %r{\.(gif|jpg|png)$}i,
		:message	=> 'Must be a URL for GIF, JPG or PNG image.'
	}
	validate :check_locale
	
	private
	
		def ensure_not_referenced_by_any_line_item
			if line_items.empty?
				return true
			else
				errors.add(:base, 'Line Items still present')
				return false
			end
		end
		
		def check_locale
		  LANGUAGES.each do |p|
		    if p[1] == locale
		      return
        end
      end
      errors.add(:locale, "#{locale} unknown")
    end
		      
		    
end
