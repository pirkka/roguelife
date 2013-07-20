module Roguelife
  class Egg < Agent
    @x_speed = 1
    @y_speed = 1
  
  end
  
  class EggBounce < AgentAction
    
    def initialize(egg, time)
      @egg = egg
      @time = time + 1
    end
    
    def resolve
      @egg.x += @egg.x_speed
      @egg.y += @egg.y_speed
      if @egg.x > 25
        @egg.x = 25
        @egg.x_speed *= -1
      end
      if @egg.y > 25
        @egg.y = 25
        @egg.y_speed *= -1
      end
    end
    
  end
  
end