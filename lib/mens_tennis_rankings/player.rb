class Player
  attr_accessor :name, :ranking, :profile_url, :age, :turned_pro, :weight, :height, :birthplace, :residence, :handedness, :coach, :cy_singles_record, :cy_singles_titles, :cy_prize_money, :career_high_rank, :career_record, :career_titles, :career_prize_money, :player_url_id, :player_wins, :opponent_wins

  @@all = []

  def initialize(player_hash)
    player_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(players_array)
    players_array.each {|player_hash| self.new(player_hash)}
  end

  def add_player_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.all
    @@all
  end
end