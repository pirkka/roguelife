module Roguelife
  class UserInterface
  
    attr_accessor :game
  
    def start
      @game = Game.new
      @game.world = WorldGenerator.generate
#      self.draw_world
      window = GameWindow.new
      window.game = @game
      window.show
    end
  
    def draw_world
      # puts "\e[H\e[2J" # clear screen
      puts Paint['Roguelife', [100, 0, 5], [0, 255, 0]]
      
      tile_map = @game.world.get_height_map
      tile_map.each do |row| 
        row.each do |column|
          if !column
            column = 0
          end
          print Paint[column, "#0c0", define_background_color(column)]
        end
        print "\n"
      end
    end
    
    def define_background_color(column)
      if !column
        column = 0
      end
      ColorConversion.hue_to_hex(110, 100, column)
    end

  end
end
