class CreatePaymentTypes < ActiveRecord::Migration
  def self.up
  	create_table :payment_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
  	PaymentType.delete_all
  	drop_table :payment_types
  end
end

