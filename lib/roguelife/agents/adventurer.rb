module Roguelife
  module Player
  
    def ai?
      false
    end
    
    def get_move_north(world)
      MoveNorth.new(self, world.time)
    end
      
  end


  class Adventurer < Roguelife::Agent
    include Roguelife::Player

    def char
      '@'
    end

    def get_action(world)
      # initial player action
      WakeUp.new(self, world.time)
    end
  end
  
  # this action is performed by the player
  class WakeUp < Roguelife::Action
    def resolve(world)
      puts "#{agent} wakes up!"
    end
  end

  class MoveNorth < Roguelife::Action
    def resolve(world)
      self.agent.y -= 1
      puts "#{agent} moves north to #{self.agent.position}"
    end
  end

  class MoveSouth < Roguelife::Action
    def resolve(world)
      puts "#{agent} moves south"
      self.agent.y += 1
    end
  end

  class MoveEast < Roguelife::Action
    def resolve(world)
      puts "#{agent} moves east"
      self.agent.x += 1
    end
  end

  class MoveWest < Roguelife::Action
    def resolve(world)
      puts "#{agent} moves west"
      self.agent.x -= 1
    end
  end

end

