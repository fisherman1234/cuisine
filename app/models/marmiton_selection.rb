class MarmitonSelection < Selection
  require 'open-uri'

  has_many :recipes

  def doc(extension)
    Nokogiri::HTML(open("#{url}?p=#{extension}"))
  end

  def import
    (0..5).to_a.each do |extension|
      cur_doc = doc(extension)
      items = cur_doc.search('//li[@class = "mrm_spiral_l1"]') + cur_doc.search('//li[@class = "mrm_spiral_l2"]')
      current_tab_name = cur_doc.search('//li[@class = "current"]').children.text
      items.each do |l|
        begin
          item_long_url = l.children[1].children[1].attributes['href'].value
          item_name = l.children.text.gsub(/\r\n/,"").squeeze().strip()
          item_id = item_long_url.match(/.*_(\d*).aspx/)[1]
          puts  [current_tab_name, item_name, item_id]
          new_recipe = Recipe.find_or_initialize_by_marmiton_id(item_id)
          new_recipe.selection_id = id
          new_recipe.title = item_name
          new_recipe.dish_type = current_tab_name
          new_recipe.save!
        rescue
        end
      end
    end
  end

  def self.import_search(query)
    doc = get_search_url(query)
    item_count = doc.search('//div[@class = "nbResultat"]').text.split(' ').last.to_i
    page_count = item_count/10 + 1
    import_result(doc)
    if page_count > 1
      (page_count-1).times do |i|
        import_result(get_search_url(query, (i+1)*10))
      end
    end
    return true
  end

  def self.import_result(data)
    items = data.search('//td[@class="miniTxtRecette" and @width="235"]')
    items.each do |item|
      begin
        url =  item.css('a').first.attributes['href'].value
        title =  item.css('a').children.text
        type =  item.children[3].text.gsub(/\r\n/,"").squeeze().strip()
        item_id = url.match(/.*_(\d*).aspx/)[1]
        new_recipe = Recipe.find_or_initialize_by_marmiton_id(item_id)
        new_recipe.title = title
        new_recipe.dish_type = type
        new_recipe.save!
      rescue
      end
    end
  end

  def self.get_search_url(query, start=0)
    base_url = "http://www.marmiton.org/recettes/recherche.aspx?aqt=#{query}&sort=&st=5&start=#{start}"
    Nokogiri::HTML(open(URI.encode(base_url)))
  end
end