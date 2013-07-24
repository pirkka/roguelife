module Roguelife
  class Agent
    
    attr_accessor :x, :y, :name
    
    def char
      'a'
    end
    
    def initialize (x,y)
      @x, @y = x, y
      @name = Names.random_name
      puts "#{self.class} #{@name} is created"
    end
    
    def to_s
      "#{self.class} #{@name} at #{@x},#{@y} (#{self.char}) #{self.object_id}"
    end
    
    def ai?
      true
    end
        
  end
end