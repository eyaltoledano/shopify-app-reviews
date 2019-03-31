# attributes = {
#   :name => "Kit",
#   :description => "Run better Facebook ads.",
#   :url => "https://apps.shopify.com/kit",
#   :categories => ["Marketing", "Productivity"],
#   :developer_name => "Shopify",
#   :developer_url => "https://www.shopify.com/kit",
#   :developer_contact => "hellokit@shopify.com"
# }

class ShopifyApp
  attr_accessor :name, :description, :url, :categories, :developer_name, :developer_url, :developer_contact, :app_reviews

  @@all = []

  def initialize(attributes)
    @name = attributes[:name]
    @description = attributes[:description]
    @url = attributes[:url]
    @categories = attributes[:categories]
    @developer_name = attributes[:developer_name]
    @developer_url = attributes[:developer_url]
    @developer_contact = attributes[:developer_contact]
    @app_reviews = []
    @@all << self
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end

  def app_reviews
    AppReview.all.each do |review|
      self.app_reviews << review if review.shopify_app == self
    end
  end

end
