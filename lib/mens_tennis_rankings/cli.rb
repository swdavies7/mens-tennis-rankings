class MensTennisRankings::CLI
  BASE_URL = "http://www.atpworldtour.com/en/rankings/singles"
  def call
    make_players
    display
  end

  def make_players
    players_array = Scraper.scrape_rankings_page(BASE_URL)
    Player.create_from_collection(players_array)
  end

  def head_to_head(tplayer)
    head_response = gets.chomp.downcase
    while head_response != "n" && head_response != "no"
      tplayer_name = tplayer.name.downcase.split(" ").join("-")
      puts "Enter an opponent's full name or rank to see #{tplayer.name}'s head-to-head record against him.".colorize(:yellow)
      opp_entry = gets.chomp
      opponent = nil
      while opponent == nil
      if opp_entry.length > 3
        if tplayer != Player.all.detect {|opponent| opponent.name.downcase == opp_entry.downcase}
          opponent = Player.all.detect {|opponent| opponent.name.downcase == opp_entry.downcase}
        end
      elsif opp_entry.length > 0 && opp_entry.length <= 3 && opp_entry.match(/^[0-9]/)
        if tplayer.ranking != Player.all[opp_entry.to_i-1].ranking
          opponent = Player.all[opp_entry.to_i-1]
        end
      else
        opponent = nil
      end
      if opponent == nil
        puts "Invalid entry. Please enter an opponent's full name or rank to see #{tplayer.name}'s head-to-head record against him.".colorize(:red)
        opp_entry = gets.chomp
      end
      end
      opponent_name = opponent.name.downcase.split(" ").join("-")
      matchup_url = "http://www.atpworldtour.com/en/players/fedex-head-2-head/#{opponent_name}-vs-#{tplayer_name}/#{opponent.player_url_id}/#{tplayer.player_url_id}"
      matchup_stats = Scraper.scrape_matchup_page(matchup_url)
      tplayer.add_player_attributes(matchup_stats)
      puts "#{tplayer.name}'s record against #{opponent.name} is #{tplayer.player_wins.colorize(:green)}-#{tplayer.opponent_wins.colorize(:red)}."
      puts "Would you like to see another matchup? Enter y or n.".colorize(:yellow)
      head_response = gets.chomp.downcase
    end
  end

  def display
    recycle = nil
    while recycle != "n" && recycle != "no"
      puts "Which players would you like to see? Enter 1-10, 11-20, 21-30, 31-40, 41-40, 51-60, 61-70, 71-80, 81-90, or 91-100.".colorize(:yellow)
      input = gets.chomp.byteslice(0, 2)
      if input.byteslice(1) == "-" || input.byteslice(1) == nil
        input = input.byteslice(0).to_i - 1
      else
        input = input.byteslice(0, 2).to_i - 1
      end
      if input <= 90
      (input..(input+9)).each do |num|
        player = Player.all[num]
        puts "#{player.ranking}.".colorize(:blue) + "#{player.name.upcase}".colorize(:light_blue)
        end
      else
        (input..99).each do |num|
        player = Player.all[num]
        puts "#{player.ranking}.".colorize(:blue) + "#{player.name.upcase}".colorize(:light_blue)
        end
      end
      puts "Which player would you like to know more about? Enter full name or rank number.".colorize(:yellow)
      response = nil
      while response == nil
        response = gets.chomp
        if response.length > 3
          aplayer = Player.all.detect {|player| player.name.downcase == response.downcase}
          if aplayer == nil
            puts "Invalid entry. Please enter an opponent's full name or rank number.".colorize(:red)
            response = nil
          else
            response = aplayer.ranking.to_i-1
          end
        elsif response.length > 0 && response.length <= 3 && response.match(/^[0-9]/)
          response = response.to_i-1
        else
          puts "Invalid entry. Please enter an opponent's full name or rank number.".colorize(:red)
          response = nil
        end
      end
      tplayer = Player.all[response]
      attributes = Scraper.scrape_profile_page(tplayer.profile_url)
      tplayer.add_player_attributes(attributes)
      puts "#{tplayer.ranking}.".colorize(:blue) + "#{tplayer.name.upcase}".colorize(:light_blue)
      puts "Age: #{tplayer.age.colorize(:green)}   Turned Pro: #{tplayer.turned_pro.colorize(:green)}   Weight: #{tplayer.weight.colorize(:green)}"+"lbs   ".colorize(:green)+"Height: #{tplayer.height.colorize(:green)}"
      puts "Birthplace: #{tplayer.birthplace.colorize(:green)}   Residence: #{tplayer.residence.colorize(:green)}   Handedness: #{tplayer.handedness.colorize(:green)}   Coach: #{tplayer.coach.colorize(:green)}"
      puts "#{Time.now.year} Record: #{tplayer.cy_singles_record.colorize(:green)}   #{Time.now.year} Titles: #{tplayer.cy_singles_titles.colorize(:green)}   #{Time.now.year} Prize Money: #{tplayer.cy_prize_money.colorize(:green)}"
      puts "Career High Ranking: #{tplayer.career_high_rank.colorize(:green)}   Career Record: #{tplayer.career_record.colorize(:green)}   Career Titles: #{tplayer.career_titles.colorize(:green)}   Career Prize Money: #{tplayer.career_prize_money.colorize(:green)}"
      puts "Would you like to see #{tplayer.name}'s head-to-head record against an opponent? Enter y or n.".colorize(:yellow)
      head_to_head(tplayer)
      puts "Would you like to know about more players? Enter y or n.".colorize(:yellow)
      recycle = gets.chomp.downcase
    end
    puts "Thanks for using the tennis-player-rankings gem. Come back soon!".colorize(:yellow)
  end
end
