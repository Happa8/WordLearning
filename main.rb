# main.rb 
require 'bundler'
Bundler.require
include SQLite3

# DB関連
$db = Database.new("./word.db")
                                                                      
if !$db.execute("SELECT tbl_name FROM sqlite_master WHERE TYPE == 'table'").flatten.include?("words")
sql_create_table = <<SQL
CREATE TABLE words (
  en_word text NOT NULL ,
  jp_word text );
SQL
$db.execute(sql_create_table)
end

keyword = ARGV[0]

target_url = "http://ejje.weblio.jp/content/" + keyword

agent = Mechanize.new
search_page = agent.get(target_url)
search_page.search('.content-explanation').each do |item|
  jp_word = item.inner_text
  if !$db.execute("SELECT en_word FROM words").flatten.include?("#{keyword}")
  $db.execute("INSERT INTO words VALUES('#{keyword}', '#{jp_word}')")
  end
  p jp_word.split("、")
end

p $db.execute2("SELECT * FROM words")
$db.close
