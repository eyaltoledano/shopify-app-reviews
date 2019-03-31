# # CLI Controller
require_relative 'app_review.rb'
require_relative 'shopify_app.rb'

class ShopifyAppReviews::CLI
  def run
    welcome
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
        display_app
      else
        app_not_found
      end
    end
  end

  def display_app # displays the app information
    puts "[App Board Placeholder]"
  end

  def app_found? # makes sure that the app exists / input is valid
     false
  end

  def app_not_found
     puts "Doesn't look like that app exists."
  end


  def goodbye
    puts "Closing CLI."
  end

end
