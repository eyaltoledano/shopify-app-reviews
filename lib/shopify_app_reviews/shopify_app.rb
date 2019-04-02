class ShopifyApp
  attr_accessor :name, :description, :url, :category, :developer_name, :developer_url, :developer_contact, :app_reviews, :overall_rating

  extend Concerns::Findable
  extend Concerns::Methods::ClassMethods
  include Concerns::Methods::InstanceMethods

  @@all = []

  def initialize(attributes)
    @name = attributes[:name]
    @url = attributes[:url]
    @category = attributes[:category]
    @developer_name = attributes[:developer_name]
    @developer_url = attributes[:developer_url]
    @description = attributes[:description] if attributes[:description]
    @overall_rating = attributes[:overall_rating] if attributes[:overall_rating]
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

  def set_sentiment(rating_type)
    sentiment = "Unknown"
    if rating_type.is_a?(String)
      rating = rating_type.split(" ").first
      rating = rating.to_f
    else
      rating = rating_type
    end
    sentiment = "terrible (#{rating}/5)".colorize(:red) if rating.between?(0.00,0.999)
    sentiment = "really bad (#{rating}/5)".colorize(:red) if rating.between?(1.00,1.999)
    sentiment = "OK at best (#{rating}/5)".colorize(:yellow) if rating.between?(2.00,2.999)
    sentiment = "good (#{rating}/5)".colorize(:yellow) if rating.between?(3.00,3.999)
    sentiment = "great (#{rating}/5)".colorize(:cyan) if rating.between?(4.00,4.499)
    sentiment = "excellent (#{rating}/5)".colorize(:cyan) if rating.between?(4.50,5.00)
    sentiment
  end

  def overall_sentiment
    set_sentiment(self.overall_rating)
  end

  def trending_sentiment
    ratings_array = []
    self.app_reviews.each do |review|
      rating = review.rating.split(" ").first.to_f
      ratings_array << rating
    end
    trending_rating = ratings_array.reduce(:+) / ratings_array.size
    set_sentiment(trending_rating)
  end

  def self.create_from_collection(app_array)
    app_array.each do |app_info|
      self.create(app_info)
    end
  end
end
