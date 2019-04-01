class AppReview
  attr_accessor :title, :body, :date, :rating, :app

  @@all = []

  def initialize(app_attributes, app = nil)
    @title = app_attributes[:title]
    @body = app_attributes[:body]
    @date = app_attributes[:date]
    @rating = app_attributes[:rating]
    @app = app if app
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

  def self.create(app_attributes, app = nil)
    a = self.new(app_attributes, app)
    a.save
  end

  def app=
    @app = app
    app.reviews << self unless app.reviews.include?(self)
  end

  def self.create_from_collection(review_array, app)
    review_array.each do |review_info|
      self.create(review_info, app)
    end
  end
end
