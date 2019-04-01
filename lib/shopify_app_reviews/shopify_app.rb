class ShopifyApp
  attr_accessor :name, :description, :url, :category, :developer_name, :developer_url, :developer_contact, :app_reviews, :overall_rating

  extend Concerns::Findable
  extend Concerns::Methods::ClassMethods
  include Concerns::Methods::InstanceMethods

  @@all = []

  def initialize(attributes)
    @name = attributes[:name]
    @description = attributes[:description] if attributes[:description]
    @overall_rating = attributes[:overall_rating] if attributes[:overall_rating]
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
    review_array = []
    AppReview.all.each do |review|
      review_array << review if review.app == self
    end
    review_array
  end

  def total_review_count
    app_reviews.count
  end

  def self.create_from_collection(app_array)
    app_array.each do |app_info|
      self.create(app_info)
    end
  end
end
