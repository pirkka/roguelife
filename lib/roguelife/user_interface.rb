module Roguelife
  class UserInterface
  
    attr_accessor :game
  
    def start
      @game = Game.new
      self.draw_world
    end
  
    def draw_world
      puts "\e[H\e[2J"
      puts Paint['Ruby', [100, 0, 5], [0, 255, 0]]
    end

  end
end
