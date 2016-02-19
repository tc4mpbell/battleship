class RandomPlayer < Player
  def initialize
  end

  def prepare_for_new_game
    @shots_to_take = (0...10).collect { |row| 
                       (0...10).collect { |col| 
                         [row, col] 
                       }
                     }.flatten(1).shuffle
  end

  def place_ships
    [
      [' ', 'C', 'C', 'C', 'C', 'C', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', 'B', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', 'B', ' ', ' ', 'D', ' '],
      [' ', ' ', ' ', ' ', ' ', 'B', ' ', ' ', 'D', ' '],
      [' ', 'P', 'P', ' ', ' ', 'B', ' ', ' ', 'D', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', 'S', 'S', 'S', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
    ]
  end

  def take_shot
    @shots_to_take.pop
  end

  def log_opponent_attack(row, col, shot_hit, sunk_ship) 
    puts "THEY ATTACKED #{row}x#{col}: #{shot_hit ? "HIT" : "MISS"} #{"-- SUNK" if sunk_ship}"
  end

  def log_last_shot(shot_hit, sunk_ship)
  end

  def log_game_won(game_won)
  end
end