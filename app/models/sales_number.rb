class SalesNumber < ActiveRecord::Base
	validates :number, format: { with: /\+\d{11}/}
end
