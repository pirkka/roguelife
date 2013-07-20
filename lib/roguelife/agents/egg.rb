module Roguelife
  class Egg < Agent
    
    attr_accessor :x_speed, :y_speed
    
    def initialize(x,y)
      super(x,y)
      @x_speed = 1
      @y_speed = 1
    end
    
    def char
      'E'
    end
    
    def get_action(world)
      EggBounce.new(self, world.time)
    end
  end
  
  class EggBounce < AgentAction
    
    def initialize(egg, time)
      @agent = egg
      @egg = @agent
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
      if @egg.x < 0
        @egg.x = 0
        @egg.x_speed *= -1
      end
      if @egg.y < 0
        @egg.y = 0
        @egg.y_speed *= -1
      end
      # then - bounce again
      
    end
    
  end
  
end