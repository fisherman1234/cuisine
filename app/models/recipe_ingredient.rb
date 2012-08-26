class RecipeIngredient < ActiveRecord::Base
  attr_accessible :amount, :ingredient_id, :recipe_id
end
