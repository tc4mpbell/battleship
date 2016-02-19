## Battleship
It's time to find out who's the better programmer, by crushing your co-workers in naval warfare. You'll do so by implementing a simple AI for playing ~~hundreds~~ thousands of games against someone else's AI. Here's how that'll work.

## What's in this repository
Everything you need to pit two Battleship AIs against each other. As well as a couple of example Battleship AIs.

## Getting Started
1. Install Gosu (for running with the GUI option). You can find install instructions for your system [here](https://github.com/gosu/gosu/wiki).

2. Install gems
    
        $ bundle install

3. Run an example game with the dummy AIs

        $ bundle exec ruby battleship.rb -o RandomPlayer -t ScannerPlayer

4. Or run an example game with the GUI
    
        $ bundle exec ruby battleship.rb -o RandomPlayer -t ScannerPlayer --gui

5. And for more options
    
        $ bundle exec ruby battleship.rb -h

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

4. `log_last_shot(shot_hit, sunk_ship)`: This method is called after you shoot at an opponent's board and provides the results of that action. `shot_hit` is a boolean, `true` if your last shot hit an opponent's ship. `sunk_ship` is a boolean, `true` if your last shot sunk an opponent's ship.

5. `log_game_won(game_won)`: This method is called at the end of a game. `game_won` is `true` if you won the game.

`players/examples/` has two examples you can use as a starting point.

### Optional methods you can implement

1. `log_opponent_attack(row, col, shot_hit, sunk_ship)`: This method is called on each of your opponent's turns, provided you've implemented it. It provides you the row,col your opponent shot at, as well as the results of that shot. Thanks @tc4mpbell, for adding that!

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

## Basic Ruby You'll Need

### Printing and Strings
`puts` prints to STDOUT. It stands for "put string". So "Hello World" in Ruby is simply:

```ruby
puts 'Hello World'
```

Concatenation and Interpolation

```ruby
name = 'John' + 'Smith' #=> 'John Smith'

first_name = 'John'
last_name = 'Smith'
full_name = first_name + last_name #=> 'John Smith'

# this is string interpolation in ruby. it requires double quotes (""). strings in double ("") are
# evaluated for interpolation and special characters like "\n" for newline.
full_name = "#{first_name} #{last_name}" #=> John Smith
```

### Branching and Loops

```ruby
# if by itself
if true
  puts 'true'
end

# if with else
if false
  puts 'false'
else
  puts 'true'
end

# if with elsif which prevents nested if/else blocks to check multiple conditions
if the_first_thing_is_true
  puts 'the first thing'
elsif the_second_thing_is_true
  puts 'the second thing'
else
  puts 'the third thing, since the first and second things were false'
end

# for simple "not" expressions we can use "unless", so this...
if !false
  puts 'true'
end

# ...equals this
unless false
  puts 'true'
end
```

A lot of classes come with enumerator methods, which should be favored when available, but some looping constructs:

```ruby
# for loop exclusive at the top end,
# prints to STDOUT:
# 0
# 1
# 2
# 3
# 4
for i in 0...5 do
  puts i
end

# for loop inclusive at the top end,
# prints to STDOUT:
# 0
# 1
# 2
# 3
# 4
# 5
for i in 0..5 do
  puts i
end

# while loop
# prints to STDOUT:
# 5
# 4
# 3
# 2
# 1
# 0
x = 5
while x >= 0 do 
  puts x
  x -= 1
end
```

### Truthy and Falsy

Everything in ruby is an object, and all objects evaluate to `true`, except `false` and `nil`:

```ruby
x = "some string"

if x
  puts 'true' # evaluated
end

if nil
  # not evaluated
end

if false
  # not evaluated
end

if 0
  puts '0' # evaluated
end
```

### Blocs

Some methods take blocks (and you'll seem some below). blocks are basically, "snippets of code" we want to run. They are defined by `{ do_stuff }` after a method call for single line blocs or the following for multi line methods:

```ruby
object.some_method_that_takes_a_bloc do
   # ...many lines of code here...
end
```

Some blocs take parameter(s) in which case we define them like so:

```ruby
object.method_with_block { |just_one_parameter| just_one_parameter.do_stuff }

object.other_method_with_block do |parameter_one, parameter_two|
  # ...do stuff with both parameters...
end
```

### Arrays

Arrays can hold any object, simultaneously. They are typically created with the implicit initializer `[]`. They have a lot of convenience methods we'll show below.

```ruby
array = [] # starts the array of empty
array.empty? #=> true

array = ['red', 'blue', 'green']
array.length #=> 3
array[0] #=> 'red'
array[1] #=> 'blue'

array[1] = 'yellow' # array is now ['red, 'yellow', 'green']
array[1] = 'blue'

array.pop #=> removes the last element of the array and returns it
          #=> array = ['red', 'blue']

array << 'green' #=> adds an element to the end of an array
                 #=> array = ['red', 'blue', 'green']

array.each { |color| puts 'color' } # prints to STDOUT:
                                    # 'red'
                                    # 'blue'
                                    # 'green'

array.each do |color| # the exact same, but with a different syntax
  puts 'color'
end

array.map { |color| color.length } # returns a new array of [3, 4, 5]

array.map(&:length) # the same as above, but a short hand way of calling .length on each element,
                    # we can do this with any method

array.collect(&:length) # collect is an alias (read the same) as map

array.map!(&:length) # changes array in place to equal [3, 4, 5]
                     # often, ruby uses methods ending in ! to symbolize that it changes data, or is
                     # unsafe

array = ['red', 'blue', 'green']

array.each_with_index { |color, index| puts index + ": " + color } # slightly different enumerator
                                                                   # that provides the index as well
```

### Symbols
Basically these are special strings for which only one ever exists (they're immutable). They start with a ":".

```ruby
x = "string"
y = "string"

# declaring two strings, doesn't make them the same object in memory
x == y #=> true
x.object_id == y.object_id #=> false

# declaring two symbols, does
x = :symbol
y = :symobl

x == y #=> true
x.object_id == y.object_id #=> true
```

Basically, because of this, Rubyists like to use symbols in hashes.

### Hashes
Hashes can hold any keys and values of any object. They are typically created with the implicit initializer `{}`. Hashes have no guaranteed order.

```ruby
hash = {} #=> creates an empty hash

# normally, we declare key, value pairs with the "hash-rocket" (=>)
hash = { 'red' => 3, 'blue' => 4, 'green' => 5 }
# hash is a hash of strings to lengths

# however, there's a special syntax for we can use for symbols called colon syntax
hash = { red: 3, blue: 4, green: 5 }
# hash is a hash of symbols to lengths

# once we have a hash we can add to it with bracket syntax []
hash[:yellow] = 6

# Enumerators exist for hashes as well, but the order here is indeterminable
hash.each do |key, value| 
  puts "#{key}: #{value}"
end

# prints to STDOUT:
# blue: 4
# green: 5
# red: 3
# yellow: 6
```

### Classes

Define a new class

```ruby
# normal class
class Person
end

# subclass
class Programmer < Person
end
```

Define an initializer. The initializer is called when `.new` is called on a class, and a new instance of that class is returned. We can define instance variables in the initializer by proceeding the variable name with an `@`. (We can create class level variables with `@@`, but you shouldn't need to do that.)

```ruby
class Person
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
end

p = Person.new('John', 'Smith')
```

Define methods on a class

```ruby
class Person
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    "#{first_name} #{last_name}" # a method returns the last expression evaluated, so this method...
  end

  def legal_name
    return "#{first_name} #{last_name}" # ... returns the same thing this one does.
  end

  def self.no_good_example # proceed a method with 'self.' to create class level methods
    'You called no_good_example on the Person class'
  end
end

p = Person.new('John', 'Smith')
p.full_name #=> John Smith
p.legal_name #=> John Smith
Person.no_good_example #=> You called no_good_example on the Person class
```

## License
To give credit where credit is due: I first saw this as a programming project in a class taught by Stephen Davies ([UMW Listing](http://www.umw.edu/directory/employee/stephen-davies/)). The code is mine, but the idea was his.

This project is in no way affiliated with any other products trademarked "Battleship". The background image in `media/` is not mine. It's watermarked by an "Eidos Studios". 

Other than that, anyone is free to do anything they would like with the remaining artifacts in this repository.