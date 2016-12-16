class SalesNumber < ActiveRecord::Base
	validates :number, format: { with: /\+\d{11}/, message: 'Please enter number in format +612345678901'}
end
