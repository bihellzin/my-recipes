class Ingredient < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3, maximum: 25 },
                   uniqueness: { case_sensitive: false }
  validates_uniqueness_of :name
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
end
