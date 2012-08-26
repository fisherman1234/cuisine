class Ingredient < ActiveRecord::Base
  require 'open-uri'

  attr_accessible :name

  def self.fetch(letter)
    url = "http://madame.lefigaro.fr/recettes/ingredients/#{letter}"
    Nokogiri::HTML(open(url))
  end


  def self.import
    ('a'..'z').to_a.each do |letter|
      page = fetch(letter)
      match = page.search('//span[@class = "field-content"]')
      ingredients = match.collect { |l| l.children.text }
      ingredients.each do |ingredient|
        Ingredient.create(:name => ingredient.singularize)
      end
    end
  end


  def self.test_ingredient_parser
    ActiveRecord::Base.logger = nil
    Treetop.load 'grammar/ingredient_lang_parser.tt'
    parser = IngredientLangParser.new
    recipes = Recipe.all.sample(10).collect{|l| l.ingredients ? l.ingredients.removeaccents.downcase : ""}
    items = recipes.collect{|l| l.split('<br>')}.collect{|l| l.split(/\r\n/)}.flatten
    success = []
    failure = []
    items.each do |item|
      subitems = item.split(' et ')
      subitems.each do |subitem|
        subitem.slice!('- ')
        if subitem
          puts "*** Debut test ***"
          puts subitem.strip.gsub(/\//, '_')
          match = parser.parse(subitem.strip)
          if match
            success.push([subitem.strip, match.ingredient.text_value])
            puts "++++ match : #{match.ingredient.text_value}" if match
          else
            failure.push(subitem.strip)
            puts '---- no match' if !match
          end
        end
      end
    end
    puts "success : #{success.count} / failure : #{failure.count}"
    [failure]
  end

  after_create :normalize_name
  def normalize_name
    self.name = self.name.removeaccents.downcase.singularize
    self.save
    true
  end

  def self.normalize_ingredients
     Ingredient.all.each do |ingredient|
         ingredient.normalize_name
     end
    true
  end

  def self.export_for_grammar
    string = Ingredient.all.collect{|l| l.name.gsub("'"){"\\'"}}.collect{|l| l.split(' ').count == 1 ? [l, l.pluralize] : l }.flatten.collect{|l| "'#{l}'"}.join(' / ')
    File.open("#{Rails.root}/grammar/ingredients.txt", 'w') do |f|
      f.puts string
    end

  end



end


# RemoveAccents version 1.0.3 (c) 2008-2009 Solutions Informatiques Techniconseils inc.
#
# This module adds 2 methods to the string class.
# Up-to-date version and documentation available at:
#
# http://www.techniconseils.ca/en/scripts-remove-accents-ruby.php
#
# This script is available under the following license :
# Creative Commons Attribution-Share Alike 2.5.
#
# See full license and details at :
# http://creativecommons.org/licenses/by-sa/2.5/ca/
#
# Version history:
#   * 1.0.3 : July 23 2009
#               Corrected some incorrect character codes. Source is now wikipedia at:
#                 http://en.wikipedia.org/wiki/ISO/IEC_8859-1#Related_character_maps
#               Thanks to Raimon Fernandez for pointing out the incorrect codes.
#   * 1.0.2 : October 29 2008
#               Slightly optimized version of urlize - Jonathan Grenier (jgrenier@techniconseils.ca)
#   * 1.0.1 : October 29 2008
#               First public revision - Jonathan Grenier (jgrenier@techniconseils.ca)
#

class String
  # The extended characters map used by removeaccents. The accented characters
  # are coded here using their numerical equivalent to sidestep encoding issues.
  # These correspond to ISO-8859-1 encoding.
  ACCENTS_MAPPING = {
      'E' => [200,201,202,203],
      'e' => [232,233,234,235],
      'A' => [192,193,194,195,196,197],
      'a' => [224,225,226,227,228,229,230],
      'C' => [199],
      'c' => [231],
      'O' => [210,211,212,213,214,216],
      'o' => [242,243,244,245,246,248],
      'I' => [204,205,206,207],
      'i' => [236,237,238,239],
      'U' => [217,218,219,220],
      'u' => [249,250,251,252],
      'N' => [209],
      'n' => [241],
      'Y' => [221],
      'y' => [253,255],
      'AE' => [306],
      'ae' => [346],
      'OE' => [188],
      'oe' => [189, 339]
  }


  # Remove the accents from the string. Uses String::ACCENTS_MAPPING as the source map.
  def removeaccents
    str = String.new(self)
    String::ACCENTS_MAPPING.each {|letter,accents|
      packed = accents.pack('U*')
      rxp = Regexp.new("[#{packed}]", nil)
      str.gsub!(rxp, letter)
    }

    str
  end


  # Convert a string to a format suitable for a URL without ever using escaped characters.
  # It calls strip, removeaccents, downcase (optional) then removes the spaces (optional)
  # and finally removes any characters matching the default regexp (/[^-_A-Za-z0-9]/).
  #
  # Options
  #
  # * :downcase => call downcase on the string (defaults to true)
  # * :convert_spaces => Convert space to underscore (defaults to false)
  # * :regexp => The regexp matching characters that will be converting to an empty string (defaults to /[^-_A-Za-z0-9]/)
  def urlize(options = {})
    options[:downcase] ||= true
    options[:convert_spaces] ||= false
    options[:regexp] ||= /[^-_A-Za-z0-9]/

    str = self.strip.removeaccents
    str.downcase! if options[:downcase]
    str.gsub!(/\ /,'_') if options[:convert_spaces]
    str.gsub(options[:regexp], '')
  end
end