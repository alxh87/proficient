class SupportNumber < ActiveRecord::Base
	validates :number, format: { with: /\A\+\d{11}\z/, message: 'Please enter number in format +612345678901'}
end
