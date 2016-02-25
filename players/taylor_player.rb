require 'benchmark'

# STRATS:
# Check every other space if randomly looking (less work, will still find them all)
# Place ships randomly, but keep track of the other guy's opening salvos, avoid placing my ships in those spots if possible

# Potential upgrades:
# - If have two hits next to each other, have a direction, so just keep checking front and back (instead of sides)
# - Don't always start top left; pick center-ish spot

# Current issues:
# Loops way too long getting a new spot to shoot
  # issue is that it's going over the same spots again and again
  # REAL issue is that the queue isn't being completely processed after a hit, so if it hits in the middle, it'll just go down the line but never come back
  # Tried to fix this by not clearing queue... dunno what's up.

class TaylorPlayer < Player
  def initialize
    @DEBUG = false

    @enemy_opening_shots = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  end

  def prepare_for_new_game
    @row = 0
    @col = -1
    @num_shots = 0
    @num_attacks = 0
    @num_openings_to_track = 10
    #@last_hit = []
    @queue = []
    

    @enemy_board = [
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
    ]

    @board = [
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
    ]

    # print_board @board

    @last_spot_tried = initial_spot_to_shoot
    puts "INIT SPOT: #{@last_spot_tried}" if @DEBUG
  end

  def place_ships
    ships = {
      C: 5,
      B: 4,
      D: 3,
      P: 2,
      S: 3
    }

    # SAMPLE: 
    # [
    #   [' ', 'C', 'C', 'C', 'C', 'C', ' ', ' ', ' ', ' '],
    #   [' ', ' ', ' ', ' ', ' ', 'B', ' ', ' ', ' ', ' '],
    #   [' ', ' ', ' ', ' ', ' ', 'B', ' ', ' ', 'D', ' '],
    #   [' ', ' ', ' ', ' ', ' ', 'B', ' ', ' ', 'D', ' '],
    #   [' ', 'P', 'P', ' ', ' ', 'B', ' ', ' ', 'D', ' '],
    #   [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    #   [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    #   [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    #   [' ', 'S', 'S', 'S', ' ', ' ', ' ', ' ', ' ', ' '],
    #   [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
    # ]

    

    ships.each do |ship, length|
      puts "SHIP: #{ship}, #{length}" if @DEBUG
      # invalid spots: 
      # - Overlapping another ship
      # - less than length spaces away from chosen edge

      direction = ['horizontal', 'vertical'].shuffle.first

      # first try: random spot
      # 2nd: avoid common openings -- to combat random, eventually need to give up avoiding common openings
      num_times_looped = 0
      loop do
        x = rand(@board[0].length - 1)
        y = rand(@board.length - 1)
        if @enemy_opening_shots[y][x] == 0 or num_times_looped > 40
          goodBoard = try_to_place(x, y, ship.to_s, length, direction) 
          
          @board = goodBoard if goodBoard
          break if goodBoard
        else
          #puts "SKIPPED: #{x} #{y}"
          num_times_looped += 1
        end
      end
    end

    @board.each do |row|
      puts "#{row}\n" if @DEBUG
    end

    @board
  end

  def try_to_place x, y, ship, length, direction
    #puts "SHIP: #{ship}, #{length}"
    return false if 
      (x + length >= @board[0].length and direction == 'horizontal') or
      (y + length >= @board.length and direction == 'vertical')

    # check for other ships
    length.times do |ix|
      if direction == 'horizontal'
        return false if @board[y][x + ix] != ' '
      else 
        return false if @board[y + ix][x] != ' '
      end
    end
    
    # valid!

    length.times do |ix|
      if direction == 'horizontal'
        @board[y][x + ix] = ship
      else
        @board[y + ix][x] = ship
      end
    end

    @board
  end

  def initial_spot_to_shoot
    # start middle-ish, fuzz it a bit by a couple in every direction
    x = (@board[0].length / 2) + rand(-3..3)
    y = (@board.length / 2) + rand(-3..3)

    [x,y]
  end

  def valid_spot_to_shoot? row, col
    (@enemy_board[row][col] == ' ' and row < @board.length and row >= 0 and col < @board[0].length and col >= 0)
  end

  # check spots 
  # - next y = y + 1
  # - next x: if x == col.len - 1 (at very end), x = 1 
  #     else x = 0
  def get_next_spot_to_shoot
    ix = 0
  
    loop do
      ix += 1
      #puts "(in loop #{ix+1})"
      # if @just_sunk
      #   @last_spot_tried = initial_spot_to_shoot 
      # else 
        last_row = @last_spot_tried[0]
        last_col = @last_spot_tried[1]

        if last_col == @board[0].length - 1 # at very last spot, so start at ix 1
          #puts "AT LAST COL: #{last_col}"
          if last_row == @board.length - 1 #at end of board; jump to top
            #puts "1. Jumped to top from #{@last_spot_tried}"
            next_row = 0
          else
            next_row = last_row + 1
          end

          @last_spot_tried = next_row, 0
        elsif last_col == @board[0].length - 2 # at 2nd to last spot, so start at ix 0
          if last_row == @board.length - 1 #at end of board; jump to top
            #puts "2. Jumped to top from #{@last_spot_tried}"
            next_row = 0
          else
            next_row = last_row + 1
          end

          @last_spot_tried = next_row, 1
        else
          if ix > 100
            # shake it upf if we've been looping too long
            @last_spot_tried = last_row, last_col + 1
          else
            @last_spot_tried = last_row, last_col + 2
          end
        end
      #end

      #puts "TRYING: #{@last_spot_tried}"

      if valid_spot_to_shoot?(@last_spot_tried[0], @last_spot_tried[1])
        @just_sunk = false # update
        break
      end
    end

    #puts "LOOKED: #{ix}"

    @last_spot_tried 
  end

  def take_shot
    ## Strategies: 
    ## 1. Only check every other cell when looking for a fresh ship
    ## 2. When have a hit but not sunk, try all around last hit
      ## 2.1 Store trail of hits, attempts;
      ## 2.2 Hit: Push attempt;
      ## 2.3 IF miss, pop and try a different one

      #######
      #####c WIP shoot algo. not working.
      #####

    @num_shots += 1

    if @queue.length > 0
      spot = @queue.pop
      puts "LOOKING AROUND LAST HIT" if @DEBUG
      print_board @enemy_board if @DEBUG
    else 
      spot = get_next_spot_to_shoot
    end

    #puts "NEW SPOT! : #{spot}"
    #puts "OUT of loop"
    #puts "SHOOTING: #{spot}" if @DEBUG
    @row = spot[0]
    @col = spot[1]
    
    return @row, @col
  end


  def log_opponent_attack(row, col, shot_hit, sunk_ship) 
    #puts "THEY ATTACKED #{row}x#{col}: #{shot_hit ? "HIT" : "MISS"} #{"-- SUNK" if sunk_ship}"

    if @num_attacks < @num_openings_to_track
      # log their attack patterns (of first two shots -- weight the first more highly)
      @enemy_opening_shots[row][col] += @num_openings_to_track - @num_attacks
    end

    @num_attacks += 1
  end

  #
  # shot algo:
  # 1. pick random (center) spot
  # 2. after a hit, queue up all around that spot
  # 3. after another hit, clear queue and queue all (untried) around that spot
  # 4. If sunk, goto 1.


  # when we get a hit, call this to queue up the next spots to try
  def update_queue_from_hit hit_row, hit_col
    # don't erase old spots, in case we hit in the middle
    #@queue = [] unless @queue
    #puts "HIT AT #{hit_row}, #{hit_col}"
    # 0,0 is topleft...
    @queue << [hit_row+1, hit_col] if valid_spot_to_shoot?(hit_row+1, hit_col)      # DOWN
    @queue << [hit_row-1, hit_col] if valid_spot_to_shoot?(hit_row-1, hit_col)      # UP
    @queue << [hit_row, hit_col+1] if valid_spot_to_shoot?(hit_row, hit_col+1)      # RIGHT
    @queue << [hit_row, hit_col-1] if valid_spot_to_shoot?(hit_row, hit_col-1)      # LEFT

    #puts "QUEUE! : #{@queue}"

    @queue
  end

  def log_last_shot(shot_hit, sunk_ship)
    #puts "BSP: #{shot_hit ? 'A HIT' : 'A MISS'}!"
    if shot_hit
      @enemy_board[@row][@col] = 'X'
      # @last_hit.push([@row, @col])

      if sunk_ship
        puts "BOOM SUNK" if @DEBUG
        @queue = []
        @just_sunk = true
      else
        update_queue_from_hit(@row, @col)
      end
    else
      @enemy_board[@row][@col] = '-'
    end

    #print_board @enemy_board
  end

  def print_board board
    board.each do |row|
      puts "#{row}\n"
    end
  end

  def log_game_won(game_won)

    if @DEBUG
      puts "\nMY BOARD"
      print_board @board

      puts "ENEMY BOARD"
      print_board @enemy_board

      puts "OPENINGS"
      @enemy_opening_shots.each do |row|
        puts "#{row}\n"
      end
      puts "\t *** #{@num_shots}"
    end
  end
end