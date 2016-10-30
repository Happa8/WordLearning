# main.rb 
require 'bundler'
Bundler.require

keyword = ARGV[0]

target_url = "http://ejje.weblio.jp/content/" + keyword

agent = Mechanize.new
search_page = agent.get(target_url)
search_page.search('.content-explanation').each do |item|
  res = item.inner_text
  p res.split("、")
end
