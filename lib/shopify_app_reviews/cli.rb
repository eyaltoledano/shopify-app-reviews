# require_relative 'shopify_app'
# require_relative 'app_review'
require_relative 'app_review_scraper'
require 'colorize'

class ShopifyAppReviews::CLI
  def run
    welcome
    get_input
    goodbye
  end

  def welcome
    hr
    puts "Welcome to Shopify App Reviews CLI.".colorize(:light_green)
  end

  def hr
    80.times { print "-".colorize(:cyan) }
    puts "-".colorize(:cyan)
  end

  def print_instructions
    puts "You can use 'exit' to leave at any time.".colorize(:yellow)
    print "Enter the slug of a Shopify app (e.g., 'reconcilely'): ".colorize(:green)
  end

  def get_input
    input = nil
    while input != "exit"
      print_instructions
      input = gets.chomp.downcase
      unless input == "exit"
        begin
          scrape_and_save_reviews(input)
        rescue OpenURI::HTTPError => e
          puts "Failed to retrieve app data: #{e.message}".colorize(:red)
        rescue StandardError => e
          puts "An error occurred: #{e.message}".colorize(:red)
        end
      end
    end
  end

  def scrape_and_save_reviews(slug)
    app_data = AppReviewScraper.scrape_app(slug)
    puts app_data
    app = ShopifyApp.new(app_data)

    puts "Scraping reviews for #{app.name}..."
    reviews = AppReviewScraper.scrape_app_reviews(slug)
    app.app_reviews = reviews.map { |review_data| AppReview.new(review_data) }

    save_reviews_to_csv(app)
  end

  def save_reviews_to_csv(app)
    CSV.open("outputs/#{app.name}_reviews.csv", "w") do |csv|
      csv << ["Store Name", "Rating", "Date", "Body", "Location", "Time Spent with App"]
      app.app_reviews.each do |review|
        csv << [review.store_name, review.rating, review.date, review.body, review.location, review.time_spent_with_app]
      end
    end
    puts "Reviews saved to #{app.name}_reviews.csv".colorize(:green)
  end

  def goodbye
    puts "Closing CLI."
  end
end

class AppReview
  attr_accessor :store_name, :rating, :date, :body, :location, :time_spent_with_app

  def initialize(review_attributes)
    @store_name = review_attributes[:store_name]
    @rating = review_attributes[:rating]
    @date = review_attributes[:date]
    @body = review_attributes[:body]
    @location = review_attributes[:location]
    @time_spent_with_app = review_attributes[:time_spent_with_app]
  end
end

class ShopifyApp
  attr_accessor :name, :url, :review_summary, :app_reviews

  def initialize(attributes)
    @name = attributes[:name]
    @url = attributes[:url]
    @review_summary = attributes[:review_summary]
    @app_reviews = []
  end
end
