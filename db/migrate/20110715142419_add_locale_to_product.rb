class AddLocaleToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :locale, :string, :default => I18n.default_locale    
  end

  def self.down
    remove_column :products, :locale
  end
end
