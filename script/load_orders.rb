Order.transaction do
	(1..100).each do |i|
		ord = Order.create( :name => "Customer #{i}", :address => "#{i} Main Street", :email => "customer-#{i}.example.com", :pay_type => "Cheque")
	end
	puts "New count of orders is: #{Order.count}"
end
