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
      puts "Search for a Shopify app by name or URL to access its information."
      puts "You can use 'exit' to leave at any time."
      print "Please enter the name or URL of a Shopify app: "
      input = gets.chomp.downcase
      if display_app_details(input) # input.include?("apps.shopify.com")
        display_app_details(input)
      else
        puts("Doesn't look like that app exists. Did you spell that right?")
      end
    end
  end

  def display_app_details(input) # if an app is not found, return falsey
    requested_app = ShopifyApp.find_by_url(input)
    requested_app = ShopifyApp.find_by_name(input) if requested_app.nil?
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
