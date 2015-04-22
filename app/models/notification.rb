class Notification < ActiveRecord::Base

belongs_to :rule
belongs_to :user

after_create :notify
  def notify
    Pusher['private-'+self.rule.user.id.to_s].trigger('client-new_message', {:stock_symbol => "#{self.rule.stock.stock_symbol} ", :stock_price => "#{self.rule.stock.price}", :target => "#{self.rule.target_price}", :image_url => "#{self.rule.stock.get_image_by_symbol}"})
    Rails.logger.debug("foo300 - #{self.id}")
  end
end
