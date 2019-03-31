# Return a hash like this:
# attributes = {
#   :name => "Kit",
#   :url => "https://apps.shopify.com/kit",
#   :category => "Marketing",
#   :developer_name => "Shopify",
#   :developer_url => "https://www.shopify.com/kit",
# }

require 'open-uri'
require 'nokogiri'
require 'pry'

class AppListScraper

  def self.scrape_shopify_apps # returns an array of Shopify App hashes
    html = open('https://asoft.co/shopify-apps/most-reviewed')
    index = Nokogiri::HTML(html)
    app_array = []
    index.css('tr').each do |row|
      unless row == index.css('tr')[0] # Skip the first row (headers)
        hash = {}
        hash[:name] = row.css('td').css('a').first.text
        hash[:url] = row.css('td').css('a')[1].attributes["href"].text
        hash[:category] = row.css('td').last.text
        hash[:developer_name] = row.css('td').css('a').last.text
        hash[:developer_url] = row.css('td').css('a').last["href"]
        app_array << hash
      end
    end
    app_array
    binding.pry
  end
end

AppListScraper.scrape_shopify_apps
