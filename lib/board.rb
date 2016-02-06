class Board
  class InvalidBoardError < StandardError
  end

  class ShotOfBoundsError < StandardError
  end

  WIDTH = 10
  HEIGHT = 10

  MARKERS = {
    carrier:    'C',
    battleship: 'B',
    submarine:  'S',
    destroyer:  'D',
    partrol:    'P',
    hit:        'X',
    empty:      ' '
  }

  LENGTHS = {
    carrier:    5,
    battleship: 4,
    submarine:  3,
    destroyer:  3,
    partrol:    2
  }

  def initialize(board)
    @board = board.dup # fresh copy of the 2D array provided
    @already_sunk = []

    raise InvalidBoardError.new("Invalid 2D array provided") unless valid?
  end

  def valid?
    @board.length == HEIGHT && 
      @board.collect(&:length).all? { |row_length| row_length == WIDTH } &&
      all_ships_present? && 
      all_ships_continuous?
  end

  # returns [ship_hit?, ship_sunk?]
  def take_shot(row, col)
    raise ShotOfBoundsError.new("row: #{row}, col: #{col}") unless row < HEIGHT && col < WIDTH
    
    marker = @board[row][col]

    # re-hit as a miss under the theory that sophisticated programs will seek and destroy
    # if they find a hit, let's not confuse the player
    return false, false if marker == MARKERS[:hit]
    
    @board[row][col] = MARKERS[:hit]

    return ship_markers.include?(marker), hit_sunk_a_ship?
  end

  def all_ships_sunk?
    (ships - @already_sunk).empty?
  end

  def to_s
    @board.collect { |row| row.collect { |m| m == MARKERS[:empty] ? '.' : m }.join(" ") }.join("\n")
  end

  private
    # ---------- validating board ----------
    def all_ships_present?
      markers_found = {}

      @board.each do |row|
        row.each do |marker|
          next unless ship_markers.include? marker # we're only counting ships

          ship = MARKERS.find { |_, m| m == marker }.first
          
          markers_found[ship] ||= 0
          markers_found[ship] += 1
        end
      end

      markers_found == LENGTHS
    end

    def all_ships_continuous?
      ships.all? do |ship|
        row, col = ships_first_coordinates(ship)

        # collect markers to the left and right of the first coordinate for the length of the ship
        markers_right = @board[row][col...(col + LENGTHS[ship])]
        markers_down = @board[row...(row + LENGTHS[ship])].collect { |r| r[col] }

        # check markers to the left and right to make sure they all equal the ship's marker
        continuous_right = markers_right.all? { |marker| marker == MARKERS[ship] }
        continuous_down  = markers_down.all?  { |marker| marker == MARKERS[ship] }
        
        # ships continuous if it's continous either to the right or down
        continuous_right || continuous_down
      end
    end

    def ships_first_coordinates(ship)
      @board.each_with_index do |row, i|
        row.each_with_index do |marker, j|
          return i, j if marker == MARKERS[ship]
        end
      end

      # TODO - better handle this error, but shouldn't come up since we check ship presence first
      throw "Unable to locate #{ship} on board"
    end

    # ---------- miscellaneous ----------
    def ships
      MARKERS.keys - [:hit, :empty]
    end

    def ship_markers
      MARKERS.select { |ship, _| ships.include? ship }.values
    end

    # ---------- calculating ship sinkage ----------
    def hit_sunk_a_ship?
      ships_off_board = ships.select { |ship| !ship_still_on_board? ship }

      # impossible to fully sink two ships at once, since ships can't overlap. if @already_sunk 
      # doesn't contain a ship that we just determined was off board then it was sunk this turn
      ship_sunk_this_turn = !(ships_off_board - @already_sunk).empty?

      # need to update @already_sunk
      @already_sunk += (ships_off_board - @already_sunk)

      ship_sunk_this_turn
    end

    def ship_still_on_board?(ship)
      @board.each do |row|
        row.each do |marker|
          return true if marker == MARKERS[ship]
        end
      end

      false
    end
end