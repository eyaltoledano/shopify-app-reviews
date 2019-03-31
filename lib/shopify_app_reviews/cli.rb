# # CLI Controller
require_relative 'app_review.rb'
require_relative 'shopify_app.rb'

class ShopifyAppReviews::CLI
  def run
    welcome
    binding.pry
    get_input
    goodbye
  end

  def welcome
    puts <<-DOC.gsub /^\s*/, ''
    There are currently 2,405 apps on the Shopify App Store.
    Search for a Shopify app by URL to access its information.
    DOC
  end

  def get_input
    input = nil
    while input != "exit"
      puts "You can use 'exit' to leave at any time."
      puts "Please enter a Shopify app URL:"
      input = gets.strip.downcase
      if input.include?("apps.shopify.com")
        display_app_details ? display_app_details : "Doesn't look like this app exists."
      else
        puts "Invalid entry. Please use a Shopify App URL."
      end
    end
  end

  def display_app_details

    # 1. search for the app
    # if an app is found, assign and puts the app board (so it's truthy)
    puts "[App Board Placeholder]"

    # if an app is not found, return false
  end

  def goodbye
    puts "Closing CLI."
  end

end
