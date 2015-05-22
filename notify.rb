require 'open-uri'
require 'nokogiri'
require 'libnotify'


class CricketScoreNotify

	def fetch_matches()
		url = "http://static.cricinfo.com/rss/livescores.xml"
		doc = Nokogiri::HTML(open(url))
		noko = doc.css("description")
		match_array= []
		noko.each {|x| match_array << x.text}
		#puts match_array
		return match_array
	end

	def notify_message(summary,body,timeout)
		Libnotify.show(:summary => summary, :body => body, :timeout => timeout)
	end

end

cric = CricketScoreNotify.new()
	match_array = cric.fetch_matches()
	puts "These are the matches going on at the moment : \n"
	match_score = Hash.new
	match_count = -1
	#puts match_array
	for match in match_array
		match_count+=1
		if(match_count==0)
			next
		end
		puts "#{match_count} - #{match}"
		match_score[match_count] = match
	end

	puts "Select the number correposnding to the match you wish to be notified of \n"
	match_selected = gets.chomp.to_i
	#puts match_score[match_selected]
	puts "Enter the time after which you wish to be notified in minutes"
	notify_time = gets.chomp
	notify_time = notify_time.to_i * 60

while true
	cric.notify_message("Live Score",match_score[match_selected],1)
	match_array = cric.fetch_matches()
	match_score = Hash.new
	match_count = -1
	#puts match_array
	for match in match_array
		match_count+=1
		if(match_count==0)
			next
		end
		match_score[match_count] = match
	end
	#puts match_score[match_selected]
	sleep(notify_time)
end