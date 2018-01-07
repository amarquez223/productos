class Product < ApplicationRecord
	has_many :catpros
	has_many :categories, through: :catpros
end
