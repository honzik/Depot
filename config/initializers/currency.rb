# add in currency exchange rate
class ExchangeRate
  @@e_rates = {
    :cs => 18.5
  }
  
  def ExchangeRate.convert_value(value)
    if @@e_rates.keys.include?I18n.locale
      return value * @@e_rates[I18n.locale]
    else
      return value
    end
  end
end
