require 'nokogiri'
require 'open-uri'

namespace :vousmevoyez do
  desc "Delete the database, Scrape Fortune.com, Update the database"
  task :update_deals => :environment do
    # delete the current database
    Deal.destroy_all

    base = Nokogiri::HTML(open("http://fortune.com/tag/term-sheet/"))
    relevant_articles = base.css('.headline').select{|t| t.text.include?("Term")}
    puts "#{relevant_articles.length} articles found"

    relevant_articles.each do |article|
      next_url = "http://www.fortune.com"+article.css('a').first.values.first
      # Obtain newest article url from Nokogiri
      article_dom = Nokogiri::HTML(open(next_url))
      venture_deals = article_dom.css('.listicle__item').select{|child|child.text.include?("VENTURE DEALS")}[0].css('p')


      keywords = ["San Francisco", "Calif"]
      # Create a deal object and add it to the database if it includes a keyword
      venture_deals.each do |deal|
        if keywords.any?{|word| deal.text.include?(word)}
          d = Deal.new
          d.company = deal.css('strong').first.text[0..-2]
          d.company_url = deal.css('a').first.values.first 
          d.detail = deal.text[2..-1]
          d.post_date = article_dom.css('.timestamp').text.strip 
          d.save
        end
      end
    end
    puts "Database has been updated"
  end

end