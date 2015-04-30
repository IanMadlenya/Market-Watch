class Rule < ActiveRecord::Base
	belongs_to :stock
	belongs_to :user
    has_many :notifications
	accepts_nested_attributes_for :stock


	validates :user, presence: true, length: { minimum: 1 }
	/validates :target_price , presence: true, numericality: true/

	attr_accessor :stock_symbol

        # called to see if main condition is met, must be overridden
        def checkTrigger
	end
      
        def getNotification
          return Hash.new({stock_symbol: stock[:stock_symbol], stock_price: stock.price,  message: message, target: target, image: stock.get_image_by_symbol})
        end

       
      
        #target predicate, override
        def target
        
        end
     
        # returns string that can be used for notification, override when necessary
        def message
           return " has reached the price of "
        end
       
        
        
        
	
	
end
