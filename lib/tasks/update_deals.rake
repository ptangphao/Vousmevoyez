namespace :vousmevoyez do
  desc "Delete the database, Scrape Fortune.com for the latest venture deals, Update the database"
  task :update_deals do
    require 'nokogiri'
    require 'open-uri'

    # delete the current database
    Deal.destroy_all

    base = Nokigiri::HTML(open("http://fortune.com/tag/term-sheet/"))
    relevant_articles = base.css('.headline').select{|t| t.text.include?("Term")}
    next_url = "http://www.fortune.com"+relevant_articles.first.css('a').first.values.first
    # Obtain newest article url from Nokogiri
    article_dom = Nokogiri::HTML(open(next_url))
    venture_deals = article_dom.css('.listicle__item').select{|child|child.text.include?("VENTURE DEALS")}[0].css('p')
    venture_deals.each do |deal|
      if deal.text.include?("San Francisco") || deal.text.include?("Calif")
        d = Deal.new
        d.company = deal.css('strong').first.text[0..-2]
        d.company_url = deal.css('a').first.values.first 
        d.detail = c.text[2..-1]
        d.save
      end
    end
    # Create new deals based on filter

    puts "Database has been updated"
  end

end