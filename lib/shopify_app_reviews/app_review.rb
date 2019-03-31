# app_attributes = {
#   :title => "Quick Deals New Zealand",
#   :body => "This app is fantastic....tech support is amazingly fast. I look forward to seeing how it performs over time.",
#   :date => "March 31, 2019",
#   :rating => 5
# }

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

end
