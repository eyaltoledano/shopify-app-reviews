# # CLI Controller
require_relative 'app_review.rb'
require_relative 'shopify_app.rb'
require_relative 'app_list_scraper.rb'

require 'colorize'

class ShopifyAppReviews::CLI
  def run
    welcome
    scrape_and_create_apps
    # add_reviews_to_apps
    library_updated
    get_input
    goodbye
  end

  def welcome
    print "The Shopify App Library is being updated. One moment."
  end

  def library_updated
    now = Time.now.asctime
    puts " Done.".colorize(:green)
    puts "Library updated as of #{now.colorize(:green)}"
    80.times {print "-".colorize(:green)}
    puts "-".colorize(:light_blue)
  end

  def get_input
    input = nil
    while input != "exit cli"
      puts "Search for a Shopify app by name or URL to access its information."
      puts "You can use 'exit cli' to leave at any time."
      print "Please enter the name or URL of a Shopify app: "
      input = gets.chomp.downcase
      binding.pry
      display_app_details(input) ? display_app_details(input) : puts("Doesn't look like that app exists. Did you spell that right?") unless input == "exit cli"
    end
  end

  def display_app_details(input) # if an app is not found, return falsey
    unless input == "exit cli"
      requested_app = ShopifyApp.find_by_url(input)
      requested_app = ShopifyApp.find_by_name(input) if requested_app.nil?
      requested_app.nil? ? false : app_table(requested_app)

      unless false
        sub_input = nil
        while !sub_input != "new app"
          puts "Use 'app reviews' to see #{requested_app.name}'s reviews.'"
          puts "Use 'app details' to review #{requested_app.name}'s details.'"
          puts "Use 'new app' to return to the previous menu."
          sub_input = gets.chomp.downcase
          if sub_input == "app reviews"
            reviews_table(requested_app)
          end
          get_input if sub_input == "new app"
          if sub_input == "exit" || sub_input == "quit" || sub_input == "exit cli"
            goodbye
            exit
          end
          app_table(requested_app) if sub_input == "app details"
        end
      end
    end
  end

  def app_table(app)
    puts app
    # show app data in a nice table/ui
  end

  def reviews_table(app)
    app.app_reviews
    # show each app review in a table format
  end

  def scrape_and_create_apps
    app_array = AppListScraper.scrape_shopify_apps
    ShopifyApp.create_from_collection(app_array)
  end

  def goodbye
    puts "Closing CLI."
  end

end
