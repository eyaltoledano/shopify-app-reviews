# attributes = {
#   :name => "Kit",
#   :description => "Run better Facebook ads.",
#   :url => "https://apps.shopify.com/kit",
#   :category => "Marketing",
#   :developer_name => "Shopify",
#   :developer_url => "https://www.shopify.com/kit",
#   :developer_contact => "hellokit@shopify.com"
# }

class ShopifyApp
  attr_accessor :name, :description, :url, :category, :developer_name, :developer_url, :developer_contact, :app_reviews

  @@all = []

  # Note that app's descroption and contact email can only be scraped by the AppReviewScraper, along all the reviews themselves.

  def initialize(attributes)
    @name = attributes[:name]
    @description = attributes[:description] if attributes[:description]
    @url = attributes[:url]
    @category = attributes[:category]
    @developer_name = attributes[:developer_name]
    @developer_url = attributes[:developer_url]
    @developer_contact = attributes[:developer_contact] if attributes[:developer_contact]
    @app_reviews = []
  end

  def self.all
    @@all
  end

  def self.destroy_all
    self.class.all.clear
  end

  def save
    self.class.all << self
  end

  def self.create(attributes)
    self.new(attributes).tap{ |a| a.save }
  end

  def app_reviews
    AppReview.all.each do |review|
      self.app_reviews << review if review.shopify_app == self
    end
  end

  def self.create_from_collection(app_array)
    app_array.each do |app_info|
      self.create(app_info)
    end
  end

end
