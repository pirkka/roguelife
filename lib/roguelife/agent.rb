module Roguelife
  class Agent
    
    attr_accessor :x, :y
    
    def char
      'a'
    end
    
    def initialize (x,y)
      @x, @y = x, y
    end
    
    def to_s
      "#{self.class} at #{@x},#{@y} (#{self.char}) #{self.object_id}"
    end
  end
end