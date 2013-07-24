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
      puts "#{agent} moves north"
      self.agent.y -= 1
    end
  end
end

