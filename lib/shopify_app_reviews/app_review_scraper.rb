require 'open-uri'
require 'nokogiri'
require 'pry'

class AppReviewScraper
  def self.scrape_app_reviews(app) # returns an array of AppReview hashes
    html = open(app.url+"/reviews")
    index = Nokogiri::HTML(html)
    review_array = []
    index.css('.review-listing').each do |review|
      hash = {}
      hash[:title] = review.css('.review-listing-header__text').text.strip
      hash[:body] = review.css('.review-content').css('p').text
      hash[:date] = review.css('.review-metadata__item')[1].css('div').children.last.text.strip
      hash[:rating] = review.css('.ui-star-rating').css('div.ui-star-rating__text').text
      hash[:app] = app
      review_array << hash
    end
    review_array
  end

  def self.scrape_app_metadata(app)
    html = open(app.url+"/reviews")
    index = Nokogiri::HTML(html)
    app.description = index.css('.ui-app-store-hero__description-text').text
    overall_rating = index.css('.ui-star-rating__rating').first.text
    app.overall_rating = overall_rating

    html2 = open(app.url)
    index2 = Nokogiri::HTML(html2)
    dev_contact = index2.css('li.app-support-list__item span').children.find do |li|
      li.text.strip if li.text.include?("@")
    end
    app.developer_contact = dev_contact.text
  end
end
