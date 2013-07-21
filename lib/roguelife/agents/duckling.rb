module Roguelife
  class Duckling < Agent

    attr_accessor :x_speed, :y_speed

    def initialize(x,y)
      super(x,y)
    end

    def char
      'q'
    end
    
    def get_action(world)
      DucklingMove.new(self, world.time)
    end
    
  end
  
  class DucklingMove < Action
    def resolve(world)
      case rand(3)
      when 0
        @agent.x += 1
      when 1
        @agent.y += 1
      when 2
        @agent.x -= 1
      when 3
        @agent.y -= 1
      end
    end
  end
  
end