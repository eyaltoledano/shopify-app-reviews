# # CLI Controller

class ShopifyAppReviews::CLI
  def run
    welcome
    get_input
  end

  def welcome
    puts <<-DOC.gsub /^\s*/, ''
    There are currently 2,405 apps on the Shopify App Store.
    Search for a Shopify app by name or by URL to access its information.
    DOC
  end

  def get_input
    puts "Please enter a Shopify app name or URL:"
    input = gets.strip

    if input.include?("apps.shopify.com")
      puts "You used an app URL"
    else
      puts "You used an app name"
    end
  end
end
