# # CLI Controller
require_relative 'app_review.rb'
require_relative 'shopify_app.rb'
require_relative 'app_list_scraper.rb'

class ShopifyAppReviews::CLI
  def run
    welcome
    scrape_and_create_apps
    # add_reviews_to_apps
    get_input
    goodbye
  end

  def welcome
    puts "The Shopify App Library is being updated. One moment."
  end

  def get_input
    input = nil
    while input != "exit"
      puts "Search for a Shopify app by URL to access its information."
      puts "You can use 'exit' to leave at any time."
      puts "Please enter a Shopify app URL:"
      input = gets.strip.downcase
      if input.include?("apps.shopify.com")
        display_app_details(input) ? display_app_details(input) : "Doesn't look like this app exists."
      else
        puts "Invalid entry. Please use a Shopify App URL."
      end
    end
  end

  def display_app_details(requested_url) # if an app is not found, return falsey
    requested_app = ShopifyApp.all.find {|app| app.url.include?(requested_url)}
    requested_app.nil? ? false : app_table(requested_app)
  end

  def app_table(app)
    app
    # show app data in a nice table/ui
    binding.pry
  end

  def scrape_and_create_apps
    app_array = AppListScraper.scrape_shopify_apps
    ShopifyApp.create_from_collection(app_array)
  end

  def goodbye
    puts "Closing CLI."
  end

end
