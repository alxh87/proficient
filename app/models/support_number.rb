class SupportNumber < ActiveRecord::Base
	validates :number, format: { with: /\A\+\d{11}\z/}
end
