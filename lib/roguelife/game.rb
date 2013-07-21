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
    # later on it could render all simulation steps until reaching to the player sim step (game pauses until player decides)
    
    self.world.resolve_next_action 
    
  end
  
  # print out various things
  def debug
    puts 'ACTION LIST'
    @world.actions.each do |action|
      puts action
    end
    puts 'AGENT LIST'
    @world.agents.each do |action|
      puts action
    end
  end
   
end