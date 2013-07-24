# the logical wrapper for the game world and other stuff that the player needs, such as messages, tutorial stuff etc.
# this might seem to be an unneeded division... eveyrthing might perhaps be in the world or game
class Game
  
  attr_accessor :world
  attr_accessor :messages_to_player

  def pause
    @paused = true
  end
  
  def unpause
    @paused = false
  end
  
  def paused?
    @paused
  end

  def initialize
    @messages_to_player = []
    @paused = true
  end
  
  def time
    self.world.time
  end
  
  def update
    if @paused
      return
    end
    # called by the gosu update method
    # let's decide that this resolves single simulation step at a time
#    self.world.resolve_next_action 
    # later on it could render all simulation steps until reaching to the player sim step (game pauses until player decides)
    # ...and even later on it could do something to keep the ui responsive
    while !@world.player_with_turn
      self.world.resolve_next_action
    end
  end
  
  # print out various things
  def debug
    puts '-------------------------------------------------------------------------------'
    puts "TIME #{self.time}"
    puts 'ACTION LIST'
    @world.actions.each do |action|
      puts action
    end
    puts 'AGENT LIST'
    @world.agents.each do |action|
      puts action
    end
  end
  
  def move_north
    if @world.player_with_turn
      @world.insert_action(Roguelife::MoveNorth.new(@world.player_with_turn, @world.time))
      @world.player_with_turn = nil
    end 
  end

  def move_south
    if @world.player_with_turn
      @world.insert_action(Roguelife::MoveSouth.new(@world.player_with_turn, @world.time))
      @world.player_with_turn = nil
    end 
  end

  def move_west
    if @world.player_with_turn
      @world.insert_action(Roguelife::MoveWest.new(@world.player_with_turn, @world.time))
      @world.player_with_turn = nil
    end 
  end

  def move_east
    if @world.player_with_turn
      @world.insert_action(Roguelife::MoveEast.new(@world.player_with_turn, @world.time))
      @world.player_with_turn = nil
    end 
  end
   
end