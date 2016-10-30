# main.rb 
require 'bundler'
Bundler.require
include SQLite3

def record(keyword)
  $db = Database.new("./word.db")
                                                                      
  if !$db.execute("SELECT tbl_name FROM sqlite_master WHERE TYPE == 'table'").flatten.include?("words")
  sql_create_table = <<SQL
  CREATE TABLE words (
    en_word text NOT NULL ,
    jp_word text );
SQL
  $db.execute(sql_create_table)
  end

  target_url = "http://ejje.weblio.jp/content/" + keyword

  agent = Mechanize.new
  search_page = agent.get(target_url)
  search_page.search('.content-explanation').each do |item|
    jp_word = item.inner_text
    if !$db.execute("SELECT en_word FROM words").flatten.include?("#{keyword}")
      $db.execute("INSERT INTO words VALUES('#{keyword}', '#{jp_word}')")
    end
    jp_word_array = jp_word.split("、")
    jp_word_array.each do |meaning|
      puts "#{meaning}\n"
    end
  end
  $db.close
end

def main
  puts "\e[H\e[2J"
  print "WordLearning\n"
  print "\t\tcreated by Happa8\n"
  print "serect mode\n\t1: record mode\n\t2: test mode\n>"
  mode = STDIN.gets.chomp
  case mode
  when "1"
   print "Please input the word\n>"
   word = STDIN.gets.chomp
   record(word)
  else
    print "Please select correct number!"
    main
  end
end

main
