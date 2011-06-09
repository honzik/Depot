class StorePriceInLineItems < ActiveRecord::Migration
  def self.up
  	LineItem.all.each do |line_item|
  		line_item.price = line_item.product.price
  		line_item.save
 		end
  end

  def self.down
  end
end
