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
    hr
    print "Welcome to Shopify App Reviews CLI.".colorize(:light_green)
    print " The Shopify App Library is updating. One moment...".colorize(:green)
  end

  def hr
    80.times {print "-".colorize(:cyan)}
    puts "-".colorize(:cyan)
  end

  def library_updated
    now = Time.now.asctime
    checkmark = "\u2713"
    puts checkmark.encode('utf-8').colorize(:light_green)
    puts "Library updated as of #{now}".colorize(:green)
    hr
  end

  def print_instructions
    puts "You can use 'exit cli' to leave at any time.".colorize(:yellow)
    puts "Search for a Shopify app by name or URL to access its information.".colorize(:green)
    print "Enter the name or URL of a Shopify app: ".colorize(:green)
  end

  def print_sub_instructions(requested_app)
    puts "Use 'latest reviews' to see #{requested_app.name}'s 10 latest reviews.".colorize(:yellow)
    puts "Use 'app details' to review #{requested_app.name}'s details.".colorize(:yellow)
    puts "Use 'new app' to return to the previous menu.".colorize(:yellow)
    print "What would you like to do? ".colorize(:green)
  end

  def get_input
    input = nil
    while input != "exit cli"
      print_instructions
      input = gets.chomp.downcase
      hr
      display_app_details(input) ? display_app_details(input) : puts("Doesn't look like an app exists for that. Did you spell your request properly?").colorize(:red) unless input == "exit cli"
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
          hr
          if requested_app.nil?
            puts("Doesn't look like an app exists for that. Did you spell your request properly?")
            get_input
          else
            print_sub_instructions(requested_app)
          end
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
    puts "Found ".colorize(:green) + "#{app.name.colorize(:white)}" + " in the ".colorize(:green) + "#{app.category.colorize(:white)}" + " category. ".colorize(:green)
    print "#{app.description.colorize(:white)}" + " - ".colorize(:green)
    puts "#{app.overall_rating.colorize(:white)}"
    puts "App URL: ".colorize(:green) + "#{app.url.colorize(:white)}"
    puts "Developer: ".colorize(:green) + "#{app.developer_name.colorize(:white)}" + " (#{app.developer_url})".colorize(:green)
    puts "Developer Contact: ".colorize(:green) + "#{app.developer_contact}".colorize(:white)

  end

  def display_app_reviews(app)
    add_reviews_to_app(app)
    total_reviews = app.total_review_count
    puts "#{app.name}'s 10 Latest Reviews:".colorize(:light_green)
    hr
    app.app_reviews.each_with_index do |review, index|
      puts "##{(index + 1)}. ".colorize(:yellow) + "#{review.title.split.map(&:capitalize).join(' ').colorize(:green)} - #{review.rating}".colorize(:green)
      puts "Reviewed on #{review.date}".colorize(:green)
      puts "#{review.body}".colorize(:green)
      hr unless review == app.app_reviews.last
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
