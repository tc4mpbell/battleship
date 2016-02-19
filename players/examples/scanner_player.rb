class ScannerPlayer < Player
  def initialize
  end

  def prepare_for_new_game
    @row = 0
    @col = -1
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
    @col += 1

    if @col >= 10 # finished row, wrap down
      @row += 1
      @col = 0
    end

    @row = 0 if @row >= 10 # game should will end before this, but just incase
    
    return @row, @col
  end

  def log_opponent_attack(row, col, shot_hit, sunk_ship) 
    puts "THEY ATTACKED #{row}x#{col}: #{shot_hit ? "HIT" : "MISS"} #{"-- SUNK" if sunk_ship}"
  end

  def log_last_shot(shot_hit, sunk_ship)
  end

  def log_game_won(game_won)
  end
end