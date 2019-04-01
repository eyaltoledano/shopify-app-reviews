class ShopifyApp
  attr_accessor :name, :description, :url, :category, :developer_name, :developer_url, :developer_contact, :app_reviews

  extend Concerns::Findable
  extend Concerns::Methods::ClassMethods
  include Concerns::Methods::InstanceMethods

  @@all = []

  # Note that app's description and contact email can only be scraped by the AppReviewScraper, along all the reviews themselves.

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

  def app_reviews
    AppReview.all.each do |review|
      self.app_reviews << review if review.shopify_app == self
    end
  end

  def total_review_count
    binding.pry
    app_reviews.count
  end

  def self.create_from_collection(app_array)
    app_array.each do |app_info|
      self.create(app_info)
    end
  end
end
