require 'open-uri'
require 'nokogiri'
require 'csv'
require 'pry'
require 'pp'

class AppReviewScraper
  BASE_URL = "https://apps.shopify.com"

  def self.scrape_app(slug)
    url = "#{BASE_URL}/#{slug}"
    html = URI.open(url)
    doc = Nokogiri::HTML4(html)

    # Attempt to find the review summary element through iteration
    review_summary = nil
    doc.css('[data-truncate-app-review-summary]').each do |element|
      if element.at_css('p[data-truncate-content-copy]')
        review_summary = element.at_css('p[data-truncate-content-copy]').text.strip
        break
      end
    end

    review_summary = review_summary || "No summary available"
    
    app_data = {
      name: slug,
      url: url,
      review_summary: review_summary
    }

    puts "Slug: #{app_data[:name]}"
    puts "URL: #{app_data[:url]}"
    puts "Review Summary:\n#{app_data[:review_summary]}"

    app_data
  end


  def self.scrape_app_reviews(slug)
    url = "#{BASE_URL}/#{slug}/reviews"
    html = URI.open(url)
    doc = Nokogiri::HTML4(html)

    total_reviews_text = doc.at_xpath('//*[@id="arp-reviews"]/div/div[3]/div[1]/h2/span[2]')&.text.strip.gsub(/[()]/, '')
    total_reviews = total_reviews_text.to_i
    total_pages = (total_reviews / 10.0).ceil
    rating = doc.at_xpath('//*[@id="arp-reviews"]/div/div[3]/div[1]/div[1]/div[2]/div[1]').text.strip
    five_star_reviews = doc.at_xpath('//*[@id="arp-reviews"]/div/div[3]/div[1]/div[1]/div[3]/ul/li[1]/div[3]/a/span').text.strip
    four_star_reviews = doc.at_xpath('//*[@id="arp-reviews"]/div/div[3]/div[1]/div[1]/div[3]/ul/li[2]/div[3]/a/span').text.strip
    three_star_reviews = doc.at_xpath('//*[@id="arp-reviews"]/div/div[3]/div[1]/div[1]/div[3]/ul/li[3]/div[3]/a/span').text.strip
    two_star_reviews = doc.at_xpath('//*[@id="arp-reviews"]/div/div[3]/div[1]/div[1]/div[3]/ul/li[4]/div[3]/a/span').text.strip
    one_star_reviews = doc.at_xpath('//*[@id="arp-reviews"]/div/div[3]/div[1]/div[1]/div[3]/ul/li[5]/div[3]/a/span').text.strip

    puts "Rating: #{rating} out of 5 stars"
    puts "5 Star Reviews: #{five_star_reviews}"
    puts "4 Star Reviews: #{four_star_reviews}"
    puts "3 Star Reviews: #{three_star_reviews}"
    puts "2 Star Reviews: #{two_star_reviews}"
    puts "1 Star Reviews: #{one_star_reviews}"
    puts "Total Reviews: #{total_reviews}"
    puts "Total Pages: #{total_pages}"
    reviews = []
    (1..total_pages).each do |page_number|
      reviews += scrape_reviews_page(slug, page_number)
      puts "Total reviews scraped so far: #{reviews.length}"
      puts "Waiting 2 seconds"
      sleep(2) # Wait for 1 second before scraping the next page
    end

    reviews
  end

  def self.scrape_reviews_page(slug, page_number)
    puts "Scraping page #{page_number}..."
    review_number = 1
    url = "#{BASE_URL}/#{slug}/reviews?page=#{page_number}"
    html = URI.open(url)
    doc = Nokogiri::HTML(html)

    reviews = []
    doc.css('div.tw-pb-md.md\\:tw-pb-lg.tw-mb-md.md\\:tw-mb-lg.tw-pt-0.last\\:tw-pb-0').each do |review|
      puts "Scraping review #{review_number}"
      review_number += 1
      rating_element = review.css('div[aria-label*="out of 5 stars"]').first
      rating = rating_element ? rating_element['aria-label'].split(" out of 5 stars").first.to_i : 0
      
      date_element = review.at_css('div.tw-text-body-xs.tw-text-fg-tertiary')
      date = date_element ? date_element.text.strip : "No date available"
      
      body_element = review.at_css('div[data-truncate-review] p.tw-break-words')
      body = body_element ? body_element.text.strip : "No body available"
      
      store_info_element = review.at_css('div.tw-order-2.lg\\:tw-order-1.lg\\:tw-row-span-2.tw-mt-md.md\\:tw-mt-0.tw-space-y-1.md\\:tw-space-y-2.tw-text-fg-tertiary.tw-text-body-xs')
      store_name = store_info_element.at_css('div.tw-text-heading-xs.tw-text-fg-primary') ? store_info_element.at_css('div.tw-text-heading-xs.tw-text-fg-primary').text.strip : "No store name available"
      location = store_info_element.css('div')[1] ? store_info_element.css('div')[1].text.strip : "No location available"
      time_spent_with_app = store_info_element.css('div')[2] ? store_info_element.css('div')[2].text.strip : "No time spent information available"

      reviews << {
        rating: rating,
        date: date,
        body: body,
        store_name: store_name,
        location: location,
        time_spent_with_app: time_spent_with_app
      }
    end

    reviews
  end
end
