class CreatePaymentTypes < ActiveRecord::Migration
  def self.up
  	create_table :payment_types do |t|
      t.string :name
      t.timestamps
    end

    PaymentType.create(:name => 'Cheque')
    PaymentType.create(:name => 'Credit card')
    PaymentType.create(:name => 'Purchase order')
  end

  def self.down
  	PaymentType.delete_all
  	drop_table :payment_types
  end
end

