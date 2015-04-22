require 'yahoofinance'
require 'json'
require 'open-uri'

class Stock < ActiveRecord::Base

  has_many :line_items
  has_many :rules
  has_many :tweets


  before_destroy :ensure_not_referenced_by_any_line_item

    #attr_accessor :stock_symbol

  def price
    prices = YahooFinance::get_quotes( YahooFinance::StandardQuote, self.stock_symbol.upcase )
    puts prices
    prices[self.stock_symbol.upcase].lastTrade
  end

  def get_image_by_symbol
    name = YahooFinance::get_quotes( YahooFinance::StandardQuote, self.stock_symbol.upcase )[self.stock_symbol.upcase].name.gsub(" ","+")
    content = open("http://api.duckduckgo.com/?q=#{name}&format=json").read
    json = JSON.parse(content)
    image = json['Image']
    if image.length < 5
      content = open("http://api.duckduckgo.com/?q=#{self.stock_symbol.upcase}&format=json").read
      json = JSON.parse(content)
      image = json['Image']
    end
    return image
  end


  def historical_price(days_ago)
    (YahooFinance::get_historical_quotes_days( self.stock_symbol, days_ago ).last.last.to_f)
  end

  def open_price
    YahooFinance::get_quotes( YahooFinance::StandardQuote, self.stock_symbol.upcase )[self.stock_symbol.upcase].open
  end

  def chart_prices(days_ago)
    prices = (YahooFinance::get_historical_quotes_days( self.stock_symbol, days_ago ))
    returned_list = []
    prices.each do |price_list|
      returned_list.push([price_list.first,price_list.last.to_f])
    end
    #returned_list = returned_list.reverse
    return [['Date','Price']]+returned_list
    #return returned_list
  end
  
  private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item 
    if line_items.empty?
      return true 
    else
      errors.add(:base, 'Line Items present')
      return false 
    end
  end

end


