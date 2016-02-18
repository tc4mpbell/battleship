class Player
  class MisplayError < StandardError
    attr_reader :player
    
    def initialize(message, player, backtrace)
      super(message)

      @player = player
      set_backtrace backtrace
    end
  end

  class Handler
    TIMEOUT = 1

    def initialize(player)
      @player = player
    end

    def method_missing(name, *args, &block)
      Timeout::timeout(TIMEOUT) { @player.send(name, *args, &block) }
    
    rescue Timeout::Error => e
      raise MisplayError.new("Player action timed out after #{TIMEOUT} seconds", @player, e.backtrace)
    
    rescue StandardError => e
      raise MisplayError.new("Player action caused error: #{e.message}", @player, e.backtrace)
    end
  end

  def self.handle
    Handler.new(self)
  end

  def handle
    Handler.new(self)
  end

  def valid?
    self.respond_to?(:prepare_for_new_game) &&
      self.respond_to?(:place_ships) &&
      self.respond_to?(:take_shot) &&
      self.respond_to?(:log_last_shot) &&
      self.respond_to?(:log_game_won)
  end
end
