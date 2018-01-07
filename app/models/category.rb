class Category < ApplicationRecord
	has_many :catpros
	has_many :products, through: :catpros
end
