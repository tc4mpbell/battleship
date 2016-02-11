require_relative File.join(File.dirname(__FILE__), 'config/loader.rb')

BattleshipOptions = Struct.new(:player_one, :player_two, :gui, :runs)

class BattleshipParser
  def self.parse(args)
    options = BattleshipOptions.new
    options.gui = false # default
    options.runs = 100

    options_parser = OptionParser.new do |opts|
      opts.banner = "Usage: battleship.rb --player_one FirstPlayer --player_two SecondPlayer [options]"

      opts.on("-o", "--player_one PlayerOne", "Must specify PlayerOne class") do |player_one|
        options.player_one = player_one
      end

      opts.on("-t", "--player_two PlayerTwo", "Must specify PlayerTwo class") do |player_two|
        options.player_two = player_two
      end

      opts.on("-r", "--runs RUNS", Integer, "Number of games to play or defaults to 100") do |runs|
        options.runs = runs
      end

      opts.on("-g", "--gui", "Run with GUI") do |gui|
        options.gui = gui
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    options_parser.parse!(args)
    return options
  end
end

# ---- begin ----
options = BattleshipParser.parse(ARGV)

# make sure players exist
if !options.player_one || !options.player_two
  puts "Must specify players: run 'bundle exec ruby battleship.rb -h' for help"
  exit
end

# make sure players are defined
begin
  player_string = options.player_one
  Object.const_get(player_string)

  player_string = options.player_two
  Object.const_get(player_string)
rescue NameError
  puts "Unable to find player class: #{player_string}. Make sure it's of the form PlayerOne and " \
       "defined in 'players/player_one.rb'"
  exit
end

# create battleship stuff
player_one = Object.const_get(options.player_one).new
player_two = Object.const_get(options.player_two).new

if options.gui
  BattleshipWindow.new(player_one, player_two, options.runs).show
else
  runner = BattleshipRunner.new(player_one, player_two)

  options.runs.times do
    runner.run_game

    player_one_wins = runner.wins[player_one]
    player_two_wins = runner.wins[player_two]

    print "\r\e[#{player_one_wins >= player_two_wins ? 32 : 31}m#{player_one.class}: #{player_one_wins}" \
            "\e[0m -- " \
            "\e[#{player_two_wins >= player_one_wins ? 32 : 31}m#{player_two.class}: #{player_two_wins}"
  end

  puts "\e[0m\n" # put the color back once program is done, and newline for prettiness
end

