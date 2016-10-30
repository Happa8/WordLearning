# main.rb 
require 'bundler'
Bundler.require
include SQLite3

$db = Database.new("./word.db")

def record(keyword)
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
end

def show
  db_data = $db.execute2("SELECT * FROM words")
  db_data.each do |item|
    puts "[#{item[0]}]"
    item[1].split("、").each do |meaning|
      puts "\t#{meaning}"
    end
    print "\n\n"
  end
end

def test
  id = rand($db.execute2("SELECT COUNT(*) from words")[1][0].to_i)+1
  meaning = $db.execute2("SELECT jp_word FROM words WHERE ROWID = #{id}")
  en_word = $db.execute2("SELECT en_word FROM words WHERE ROWID = #{id}")[1][0]
  puts "meaning :"
  meaning[1][0].split("、").each do |item|
    puts item
  end
  print "answer>"
  input_word = STDIN.gets.chomp
  if input_word == en_word
    puts "It is correct answer!"
  else
    puts "It is incorrect answer...\nCorrect answer is \"#{en_word}\""
  end
end

def main
  puts "\e[H\e[2J"
  print "WordLearning\n"
  print "\t\tcreated by Happa8\n"
  print "serect mode\n\t1: record mode\n\t2: test mode\n\t3: show mode\n>"
  mode = STDIN.gets.chomp
  case mode
  when "1"
   print "Please input the word\n>"
   word = STDIN.gets.chomp
   record(word)
  when "2"
   test
  when "3"
    show
  else
    print "Please select correct number!"
    main
  end
end

main

$db.close
