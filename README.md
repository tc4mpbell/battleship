## Battleship
It's time to find out who's the better programmer, by crushing your co-workers in naval warfare. You'll do so by implementing a simple AI for playing ~~hundreds~~ thousands of games against someone else's AI. Here's how that'll work.

## What's in this repository
Everything you need to pit two Battleship AIs against each other. As well as a couple of example Battleship AIs.

## Getting Started
1. Install Gosu (for running with the GUI option). You can find install instructions for your system [here](https://github.com/gosu/gosu/wiki).

2. Install gems
    
        $ bundle install

3. Run an example game with the dummy AIs

        $ bundle exec ruby -o RandomPlager -t ScannerPlayer

4. Or run an example game with the GUI
    
        $ bundle exec ruby -o RandomPlager -t ScannerPlayer --gui

5. And for more options
    
        $ bundle exec ruby -h

## How do I make my own player?
It's easy! Just create a file in `players/`. In that file, you'll define a class that extends `Player` so:

```ruby
class SmartPlayer < Player
  # do cool stuff
end
```

### Your player class is responsible for implementing the following methods

1. `prepare_for_new_game`: This method gets called at the start of every new game. Anything your player needs to do to get ready for a game should be done here.

2. `place_ships`: This method returns a 10x10 2D array that represents a board. `lib/board.rb` has `Board::MARKERS` and `Board::LENGTHS` that define what markers you should use to represent a ship being in that space. Your board will be validated to ensure that all ships exist, are the appropriate length, and are all continuous.

3. `take_shot`: This method returns a `row` and `col` that represent the shot you would like to take on your opponent's board. Obviously, both should fall within the range 0-9. And this will be called on each of your turns.

4. `log_last_shot(shot_hit, sunk_ship)`: `shot_hit` is a boolean, `true` if your last shot hit an opponent's ship. `sunk_ship` is a boolean, `true` if your last shot sunk an opponent's ship.

5. `log_game_won(game_won)`: This method is called at the end of a game. `game_won` is `true` if you won the game.

`players/examples/` has two examples you can use as a starting point.

## Rules
Besides the actual [battleship rules](https://en.wikipedia.org/wiki/Battleship_(game)), there are four additional rules:
1. No cheating! The point of this exercise is not to manipulate Ruby's object space--it's to create a better Battleship player.
2. If your player class fails to return a valid board, you lose the game.
3. If your player class causes an error at anytime, you lose the game.
4. If your player class fails to complete any of the 5 methods in 1 second or less, you lose the game. **I may adjust this to a shorter timeout.**

## What's that .irbrc file?
I like to have project specific irb settings that take care of loading all the objects I may need. You can take advantage of this by adding the following to your `~/.irbrc` file:

```ruby
# loads project specific (i.e. located in project directories) .irbrc files
def load_irbrc(path)
  return if (path == ENV["HOME"]) || (path == '/')

  load_irbrc(File.dirname path)

  irbrc = File.join(path, ".irbrc")

  load irbrc if File.exists?(irbrc)
end
load_irbrc Dir.pwd # starts the .irbrc load process, and should stay at the bottom
```

## What's that loader.rb file?
It loads all of our gems and class files. `battleship.rb` (the executable file) requires that file, and by doing so takes care of all of our dependency loading. This mimics a "rails-like" auto-loading setup. 

## Contributing
Please do! Game enhancements, code enhancements, whatever!

## License
To give credit where credit is due: I first saw this as a programming project in a class taught by Stephen Davies ([UMW Listing](http://www.umw.edu/directory/employee/stephen-davies/)). The code is mine, but the idea was his.

This project is in no way affiliated with any other products trademarked "Battleship". The background image in `media/` is not mine. It's watermarked by an "Eidos Studios". 

Other than that, anyone is free to do anything they would like with the remaining artifacts in this repository.