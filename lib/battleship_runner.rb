# TODO - implement cli
#      - autoloading classes in player dir
#      - sexy gui

class BattleshipRunner
  attr_reader :wins

  def initialize(player_one, player_two)
    @boards = {
      player_one => nil,
      player_two => nil
    }

    @wins = {
      player_one => 0,
      player_two => 0
    }
  end

  def run_game
    prepare_players_for_new_game
    reset_boards
    play_game if boards_valid?

    record_wins
  rescue Player::MisplayError => e # if someone misplays, other player wins
    puts "Player Misplayed: #{e.message}\n#{e.backtrace.join("\n")}"
    record_misplay e.player
  end

  private
    def prepare_players_for_new_game
      @boards.keys.each(&:prepare_for_new_game)
    end

    def reset_boards
      @boards.keys.each do |player| 
        @boards[player] = begin 
                            Board.new(player.handle.place_ships)
                          rescue Board::InvalidBoardError
                            nil
                          end
      end
    end

    def play_game
      play_order = @boards.keys.shuffle # TODO - maybe loser of last game should go first?
      turn = 0

      begin
        shooting = shooting_player(play_order, turn)
        answering = answering_player(play_order, turn)

        row, col = shooting.handle.take_shot

        shot_hit, sunk_ship = begin 
                                @boards[answering].take_shot(row, col) 
                              rescue Board::ShotOfBoundsError
                                [false, false]
                              end

        shooting.handle.log_last_shot(shot_hit, sunk_ship)

        turn += 1
      end until game_over?
    end

    def shooting_player(play_order, turn)
      play_order[turn % play_order.length]
    end

    def answering_player(play_order, turn)
      play_order[(turn + 1) % play_order.length]
    end

    def game_over?
      # impossible to tie a game since turn based
      @boards.values.any?(&:all_ships_sunk?)
    end

    def boards_valid?
      @boards.values.all? { |board| !board.nil? } # use nil to represent invalid board in reset
    end

    def record_wins
      @boards.each do |player, board|
        if board.nil? || board.all_ships_sunk? # it's invalid or he lost
          # giver every other player a win
          @wins.keys.each { |other_player| @wins[other_player] += 1 unless other_player == player }
        end
      end
    end

    def record_misplay(player)
      # giver every other player a win
      @wins.keys.each { |other_player| @wins[other_player] += 1 unless other_player == player }
    end
end