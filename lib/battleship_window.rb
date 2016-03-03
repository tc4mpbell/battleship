class BattleshipWindow < Gosu::Window
  WIDTH = 1280
  HEIGHT = 800

  def initialize(player_one, player_two, runs)
    super WIDTH, HEIGHT
    self.caption = 'Battleship'

    @background_image = Gosu::Image.new("media/background_2560_1600.jpg", :tileable => true)
    @font = Gosu::Font.new(64)

    @player_one = player_one
    @player_two = player_two
    @runs = runs
    @runs_completed = 0

    @runner = BattleshipRunner.new(@player_one, @player_two)

    @player_one_win_count = @runner.wins[@player_one]
    @player_two_win_count = @runner.wins[@player_two]

    @grid_spacing = 50
    @grid_size = 12
  end

  def update
    timer = 0
    if @runs_completed < @runs and timer < 1000000
      @runner.run_game
      @runs_completed += 1
      timer = 0
    end

    timer+=1

    @player_one_win_count = @runner.wins[@player_one]
    @player_two_win_count = @runner.wins[@player_two]
  end

  def draw
    @background_image.draw(0, 0, 0, WIDTH / 2560.0, HEIGHT / 1600.0, Gosu::Color::GRAY)

    # draw player labels
    @font.draw_rel(@player_one.class.to_s, (WIDTH / 4), 10, 1, 0.5, 0.0, 1, 1, Gosu::Color::WHITE)
    @font.draw_rel(@player_two.class.to_s, (WIDTH / 4) * 3, 10, 1, 0.5, 0.0, 1, 1, Gosu::Color::WHITE)

    # win bar calculations
    win_height = ((HEIGHT / 4) * 3) / @runs
    width_sixteenths = WIDTH / 16.0

    # draw player one bar and count
    draw_quad(
      width_sixteenths * 3, HEIGHT - win_height * @player_one_win_count, Gosu::Color::WHITE,
      width_sixteenths * 5, HEIGHT - win_height * @player_one_win_count, Gosu::Color::WHITE,
      width_sixteenths * 3, HEIGHT, Gosu::Color::WHITE,
      width_sixteenths * 5, HEIGHT, Gosu::Color::WHITE,
      1
    )

    @font.draw_rel(
      @player_one_win_count.to_s,
      width_sixteenths * 4,
      HEIGHT - win_height * @player_one_win_count - @font.height - 10,
      1, 0.5, 0.0, 1, 1, Gosu::Color::WHITE
    )

    # draw player two bar and count
    draw_quad(
      width_sixteenths * 11, HEIGHT - win_height * @player_two_win_count, Gosu::Color::WHITE,
      width_sixteenths * 13, HEIGHT - win_height * @player_two_win_count, Gosu::Color::WHITE,
      width_sixteenths * 11, HEIGHT, Gosu::Color::WHITE,
      width_sixteenths * 13, HEIGHT, Gosu::Color::WHITE,
      1
    )

    @font.draw_rel(
      @player_two_win_count.to_s,
      width_sixteenths * 12,
      HEIGHT - win_height * @player_two_win_count - @font.height - 10,
      1, 0.5, 0.0, 1, 1, Gosu::Color::WHITE
    )


    @runner.instance_variable_get(:@boards).each do |player, board|
      offset_y = 50
      if @player_one == player
        offset_x = 50
      else
        offset_x = 700
      end
      #BOARDS
      
      
      @grid_size.times do |ix|
        puts "ix #{ix}"
        draw_line(ix*@grid_spacing+offset_x, @grid_spacing+offset_y, Gosu::Color::WHITE, ix*@grid_spacing+offset_x, @grid_spacing*@grid_size-@grid_spacing+offset_y, Gosu::Color::WHITE)
        draw_line(@grid_spacing+offset_x, ix*@grid_spacing+offset_y, Gosu::Color::WHITE, @grid_spacing*@grid_size-@grid_spacing+offset_x, ix*@grid_spacing+offset_y, Gosu::Color::WHITE)
      end

      board_array = board.instance_variable_get(:@board)

      board_array.each_with_index do |row,y|
        row.each_with_index do |col,x|
          if col != ' ' and col != 'X' # not empty or hit
            # ship
            top, left = board_xy_to_world_xy(x, y, offset_x, offset_y)

            draw_triangle(top+@grid_spacing-2, left+2, Gosu::Color::YELLOW, top+2, left+@grid_spacing-2, Gosu::Color::GREEN, top+@grid_spacing-2, left+@grid_spacing-2, Gosu::Color::BLUE)
          end
        end
      end

      puts "player: #{player} - b: #{board}"
    end

  end

  # returns top left of the space at X,Y in the board array
  def board_xy_to_world_xy x, y, offset_x, offset_y
    return x*@grid_spacing+offset_x, y*@grid_spacing+offset_y
  end

  def needs_cursor?
    true # i just like it
  end
end

# ---- begin ----
# window = BattleshipWindow.new(RandomPlayer.new, ScannerPlayer.new, 100)
# window.show