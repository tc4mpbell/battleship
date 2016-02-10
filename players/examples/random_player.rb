class RandomPlayer < Player
  def initialize
  end

  def prepare_for_new_game
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
    return rand(10), rand(10)
  end

  def log_last_shot(shot_hit, sunk_ship)
  end

  def log_game_won(game_won)
  end
end