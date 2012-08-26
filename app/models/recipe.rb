class Recipe < ActiveRecord::Base
  require 'open-uri'
  require "net/http"
  require "uri"

  attr_accessible :difficulty, :preparation_time, :price, :cooking_time, :selection_id, :rating, :title, :instructions, :dish_type, :cost , :is_vegetarian  , :picture_url , :marmiton_id, :ingredients

  belongs_to :marmiton_selection, :foreign_key => :selection_id

  def fetch
    url = "http://m.marmiton.org/webservices/json.svc/GetRecipeById?SiteId=1&appversion=mmtiphfrora&RecipeId=#{marmiton_id}"
    http_get = Net::HTTP.get(URI.parse(url))
    puts url
    JSON.parse(http_get)
  end

  def page_url
    fetch["data"]["items"].first["pageURL"]
  end

  def import
    data = fetch["data"]["items"].first
    self.difficulty = data["difficulty"]
    self.preparation_time=data["preparationTime"].match(/(\d*)/)[1]
    self.cost = data["cost"]
    self.cooking_time=data["cookingTime"].match(/(\d*)/)[1]
    self.rating=data["rating"]
    self.instructions=data["preparationList"]
    if self.instructions.nil?
      self.instructions = data["text"]
    end
    self.is_vegetarian = data["isVegetarian"]
    self.picture_url= data["pictures"].first["url"] if data["pictures"].first
    self.ingredients= data["ingredientList"]
    self.save!
  end


  def self.import_all
    Recipe.where("instructions is null").each do |recipe|
      recipe.import
      sleep_time = rand(5)
      puts "sleeps for #{sleep_time}"
      sleep sleep_time
    end

  end
end