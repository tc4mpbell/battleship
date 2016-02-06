require File.join(Dir.pwd, 'config/loader.rb')

def setup
  r = RandomPlayer.new
  s = ScannerPlayer.new
  runner = BattleshipRunner.new(r, s)
  return r, s, runner
end