class Scraper

  def self.scrape_rankings_page(rankings_url)
    doc = Nokogiri::HTML(open(rankings_url))
    players_array = []
      doc.css("tbody tr").each do |player|
        players_hash = {name: player.css(".player-cell a").text.strip, ranking: player.css(".rank-cell").text.strip, profile_url: "http://www.atpworldtour.com#{player.css(".player-cell a").attribute("href").value}", player_url_id: "http://www.atpworldtour.com#{player.css(".player-cell a").attribute("href").value}".byteslice(-13, 4)}
        players_array << players_hash
      end
    players_array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
      hash = {age: doc.css("td:nth-child(1) .table-big-value").text.strip.byteslice(0, 2), turned_pro: doc.css("td:nth-child(2) .table-big-value").text.strip, weight: doc.css(".table-weight-lbs").text.strip, height: doc.css(".table-height-ft").text.strip, birthplace: doc.css("td:nth-child(1) .table-value").text.strip, residence: doc.css("td:nth-child(2) .table-value").text.strip, handedness: doc.css("td:nth-child(3) .table-value").text.strip, coach: doc.css("td:nth-child(4) .table-value").text.strip, cy_singles_record: doc.css("tr:nth-child(1) td:nth-child(5) .stat-value").text.strip, cy_singles_titles: doc.css("td:nth-child(6) .stat-value").text.strip, cy_prize_money: doc.css("td:nth-child(7) .stat-value").text.strip, career_high_rank: doc.css("td:nth-child(2) .stat-value").text.strip, career_record: doc.css("td~ td+ td:nth-child(3) .stat-value").text.strip, career_titles: doc.css("tr+ tr td:nth-child(4) .stat-value").text.strip, career_prize_money: doc.css("tr+ tr td:nth-child(5) .stat-value").text.strip}
      hash
  end

  def self.scrape_matchup_page(matchup_url)
    doc = Nokogiri::HTML(open(matchup_url))
      hash = {player_wins: doc.css(".player-right-wins .players-head-rank").text.strip, opponent_wins: doc.css(".player-left-wins .players-head-rank").text.strip}
      hash
  end

end

