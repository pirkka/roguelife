module Roguelife
  class Agent
    
    attr_accessor :x, :y
    
    def char
      'a'
    end
    
    def initialize (x,y)
      @x, @y = x, y
    end
  end
end