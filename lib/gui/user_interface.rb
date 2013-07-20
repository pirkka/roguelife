module Roguelife
  class UserInterface
  
    attr_accessor :game
  
    def start
      @game = Game.new
      @game.world = WorldGenerator.generate
      self.draw_world
      window = GameWindow.new
      window.game = @game
      window.show
    end
  
    def draw_world
      puts "\e[H\e[2J"
      puts Paint['Roguelife', [100, 0, 5], [0, 255, 0]]
      
      tile_map = @game.world.get_height_map
      tile_map.each do |row| 
        row.each do |column|
          print Paint[(column/10).round, "#0c0", define_background_color(column)]
        end
        print "\n"
      end
    end
    
    def define_background_color(column)
      
      ColorConversion.hue_to_rgb(110, 100, column)
    end

  end
end
