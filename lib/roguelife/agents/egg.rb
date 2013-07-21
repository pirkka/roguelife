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
      if (rand(10) == 0)
        EggCrack.new(self, world.time)
      else
        EggBounce.new(self, world.time)
      end
    end
  end
  
  class EggCrack < Action
    def initialize(agent, time)
      @agent = agent
      @time = time + 1
    end

    def resolve(world)
      # something comes out of the egg
      world.insert_agent Duckling.new(@agent.x+1, @agent.y)
      world.insert_agent Duckling.new(@agent.x-1, @agent.y)
      world.insert_agent Duckling.new(@agent.x, @agent.y+1)
      world.insert_agent Duckling.new(@agent.x, @agent.y-1)
      # egg is removed
      world.remove_agent @agent
    end
  end
  
  class EggBounce < Action
    
    def initialize(agent, time)
      @agent = agent
      @time = time + 1
    end
    
    def resolve(world)
      @agent.x += @agent.x_speed
      @agent.y += @agent.y_speed
      if @agent.x > 25
        @agent.x = 25
        @agent.x_speed *= -1
      end
      if @agent.y > 25
        @agent.y = 25
        @agent.y_speed *= -1
      end
      if @agent.x < 0
        @agent.x = 0
        @agent.x_speed *= -1
      end
      if @agent.y < 0
        @agent.y = 0
        @agent.y_speed *= -1
      end
      # then - bounce again
      world.insert_action(@agent.get_action(world))
    end
    
  end
  
end