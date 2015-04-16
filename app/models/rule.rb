class Rule < ActiveRecord::Base
	belongs_to :stock
	belongs_to :portfolio
        has_many :notifications
	accepts_nested_attributes_for :stock


	validates :portfolio, presence: true, length: { minimum: 1 }
	/validates :target_price , presence: true, numericality: true/

	attr_accessor :stock_symbol
end
