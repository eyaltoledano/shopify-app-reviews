# # CLI Controller
require_relative 'app_review.rb'
require_relative 'shopify_app.rb'
require_relative 'app_list_scraper.rb'
require_relative 'app_review_scraper.rb'

require 'colorize'

class ShopifyAppReviews::CLI
  def run
    welcome
    scrape_and_create_apps
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
    puts "-".colorize(:green)
  end

  def get_input
    input = nil
    while input != "exit cli"
      puts "Search for a Shopify app by name or URL to access its information."
      puts "You can use 'exit cli' to leave at any time."
      print "Please enter the name or URL of a Shopify app: "
      input = gets.chomp.downcase
      display_app_details(input) ? display_app_details(input) : puts("Doesn't look like an app exists for that. Did you spell your request properly?") unless input == "exit cli"
    end
  end

  def display_app_details(input) # if an app is not found, return falsey
    unless input == "exit cli"
      requested_app = ShopifyApp.find_by_url(input)
      requested_app = ShopifyApp.find_by_name(input) if requested_app.nil?
      requested_app.nil? ? false : app_details_table(requested_app)

      unless false
        sub_input = nil
        while !sub_input != "new app"
          puts "Use 'latest reviews' to see #{requested_app.name}'s 10 latest reviews.'".colorize(:yellow)
          puts "Use 'app details' to review #{requested_app.name}'s details.'".colorize(:yellow)
          puts "Use 'new app' to return to the previous menu.".colorize(:yellow)
          sub_input = gets.chomp.downcase
          if sub_input == "latest reviews"
            display_app_reviews(requested_app)
          end
          get_input if sub_input == "new app"
          if sub_input == "exit" || sub_input == "quit" || sub_input == "exit cli"
            goodbye
            exit
          end
          app_details_table(requested_app) if sub_input == "app details"
        end
      end
    end
  end

  def app_details_table(app)
    add_metadata_to_app(app)
    puts "Found #{app.name.colorize(:green)} in the #{app.category.colorize(:green)} category."
    print "#{app.description.colorize(:green)} - "
    puts "Rated #{app.overall_rating.colorize(:green)}"
    puts "#{app.url.colorize(:green)}"
    puts "Developed by: #{app.developer_name.colorize(:green)} (#{app.developer_url})"
    puts "Developer Contact: #{app.developer_contact}"

  end

  def display_app_reviews(app)
    add_reviews_to_app(app)
    total_reviews = app.total_review_count
    puts "Here are #{app.name}'s 10 latest reviews:'"
    puts "--------------------------".colorize(:green)
    app.app_reviews.each_with_index do |review, index|
      puts "##{index + 1}. #{review.title.split.map(&:capitalize).join(' ')} - #{review.rating}"
      puts "Reviewed on #{review.date}"
      puts "#{review.body}"
      puts "--------------------------".colorize(:green)
    end
  end

  def scrape_and_create_apps
    app_array = AppListScraper.scrape_shopify_apps
    ShopifyApp.create_from_collection(app_array)
  end

  def add_reviews_to_app(app)
    review_array = AppReviewScraper.scrape_app_reviews(app)
    AppReview.create_from_collection(review_array, app)
    app.app_reviews << review_array
  end

  def add_metadata_to_app(app)
    metadata = AppReviewScraper.scrape_app_metadata(app)
  end

  def goodbye
    puts "Closing CLI."
  end

end
