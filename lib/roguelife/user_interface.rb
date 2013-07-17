module Roguelife
  class UserInterface
  
    attr_accessor :game
  
    def start
      @game = Game.new
      @game.world = WorldGenerator.generate
      self.draw_world
    end
  
    def draw_world
      puts "\e[H\e[2J"
      puts Paint['Roguelife', [100, 0, 5], [0, 255, 0]]
      
      tile_map = @game.world.get_height_map
      tile_map.each do |row| 
        row.each do |column|
          print column
        end
        print "\n"
      end
    end

  end
end
