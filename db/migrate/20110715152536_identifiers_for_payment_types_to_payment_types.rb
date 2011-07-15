class IdentifiersForPaymentTypesToPaymentTypes < ActiveRecord::Migration
  @old_values = {:chq => "Cheque", :cc => "Credit card", :pp => "Purchase order"}
  
  def self.up    
    @old_values.each do |new_id, value|
      pt = PaymentType.find_by_name(value)
      if !(pt.nil?)
        pt.name = new_id.to_s
        pt.save
        Order.update_all("pay_type = '#{new_id.to_s}'", "pay_type like '#{value}'")
      end
    end       
  end

  def self.down
    @old_values.each do |curr_id, new_value|
      pt = PaymentType.find_by_name(curr_id.to_s)
      if !(pt.nil?)
        pt.name = new_value
        pt.save
        Order.update_all("pay_type = '#{new_value}'", "pay_type like '#{curr_id.to_s}'")
      end
    end       
  
  end
end
